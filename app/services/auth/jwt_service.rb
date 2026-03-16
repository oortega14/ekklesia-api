# app/services/auth/jwt_service.rb
module Auth
  class JwtService
    ACCESS_TOKEN_TTL  = 15.minutes
    REFRESH_TOKEN_TTL = 30.days

    ALGORITHM = "HS256".freeze

    def self.encode_access_token(user, org_id: user.organization_id)
      payload = {
        sub:   user.id,
        org:   org_id,
        role:  user.role,
        jti:   SecureRandom.uuid,
        iat:   Time.current.to_i,
        exp:   ACCESS_TOKEN_TTL.from_now.to_i
      }
      JWT.encode(payload, secret, ALGORITHM)
    end

    def self.decode(token)
      decoded = JWT.decode(
        token,
        secret,
        true,
        { algorithm: ALGORITHM, verify_expiration: true }
      )
      decoded.first.with_indifferent_access
    rescue JWT::ExpiredSignature
      raise Auth::Errors::TokenExpired
    rescue JWT::DecodeError
      raise Auth::Errors::TokenInvalid
    end

    def self.secret
      Rails.application.credentials.jwt_secret!
    end
  end
end
