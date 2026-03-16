# app/models/refresh_token.rb
class RefreshToken < ApplicationRecord
  belongs_to :user
  belongs_to :organization, optional: true

  validates :token_digest, :jti, :expires_at, presence: true

  scope :active, -> {
    where(revoked_at: nil)
      .where("expires_at > ?", Time.current)
  }

  def self.generate_for(user, device_info = {}, organization: nil)
    raw_token = SecureRandom.urlsafe_base64(64)
    hmac      = OpenSSL::HMAC.hexdigest("SHA256", hmac_secret, raw_token)

    record = create!(
      jti:          SecureRandom.uuid,
      token_digest: BCrypt::Password.create(raw_token),
      token_hmac:   hmac,
      user:            user,
      organization:    organization || user.organization,
      expires_at:      30.days.from_now,
      device_name:     device_info[:device_name],
      ip_address:      device_info[:ip_address],
      user_agent:      device_info[:user_agent]
    )

    { record: record, raw_token: raw_token }
  end

  def self.find_and_verify(raw_token)
    # Busca por digest — no guardamos el token en claro
    # Itera solo sobre tokens activos del periodo reciente
    # En producción considera un campo de búsqueda con HMAC
    active.find_each do |rt|
      return rt if BCrypt::Password.new(rt.token_digest) == raw_token
    end
    nil
  end

  def revoke!(reason: "logout")
    update!(revoked_at: Time.current, revoke_reason: reason)
  end

  def active?
    revoked_at.nil? && expires_at > Time.current
  end

  def self.find_and_verify(raw_token)
    hmac   = OpenSSL::HMAC.hexdigest("SHA256", hmac_secret, raw_token)
    record = active.find_by(token_hmac: hmac)
    return nil unless record
    BCrypt::Password.new(record.token_digest) == raw_token ? record : nil
  end

  def self.hmac_secret
    Rails.application.credentials.refresh_token_hmac_secret!
  end
end
