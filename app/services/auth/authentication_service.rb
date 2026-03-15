# app/services/auth/authentication_service.rb
module Auth
  class AuthenticationService
    Result = Struct.new(:success?, :user, :access_token,
                        :refresh_token, :error, keyword_init: true)

    def self.login(email:, password:, device_info: {})
      user = User.find_by(email: email.downcase)

      unless user&.authenticate(password)
        return Result.new(success?: false, error: "Credenciales inválidas")
      end

      unless user.active?
        return Result.new(success?: false, error: "Cuenta desactivada")
      end

      access_token          = JwtService.encode_access_token(user)
      refresh_token_data    = RefreshToken.generate_for(user, device_info)

      user.update_columns(
        last_sign_in_at: Time.current,
        last_sign_in_ip: device_info[:ip_address]
      )

      Result.new(
        success?:      true,
        user:          user,
        access_token:  access_token,
        refresh_token: refresh_token_data[:raw_token]
      )
    end

    def self.refresh(raw_refresh_token)
      record = RefreshToken.find_and_verify(raw_refresh_token)

      unless record&.active?
        return Result.new(success?: false, error: "Refresh token inválido")
      end

      # Rotación — revoca el viejo, emite uno nuevo
      record.revoke!(reason: "rotated")
      user = record.user

      new_access        = JwtService.encode_access_token(user)
      new_refresh_data  = RefreshToken.generate_for(user)

      Result.new(
        success?:      true,
        user:          user,
        access_token:  new_access,
        refresh_token: new_refresh_data[:raw_token]
      )
    end

    def self.logout(raw_refresh_token)
      record = RefreshToken.find_and_verify(raw_refresh_token)
      record&.revoke!(reason: "logout")
      Result.new(success?: true)
    end
  end
end
