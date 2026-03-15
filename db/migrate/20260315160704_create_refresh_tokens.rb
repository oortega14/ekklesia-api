class CreateRefreshTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :refresh_tokens do |t|
      t.references :user,        null: false, foreign_key: true
      t.references :organization, foreign_key: true
      # desnormalizado para revocar por tenant fácilmente

      t.string  :token_digest,   null: false   # bcrypt del token
      t.string  :jti,            null: false   # JWT ID único
      t.string  :device_name                   # "iPhone de Juan"
      t.string  :ip_address
      t.string  :user_agent
      t.datetime :expires_at,    null: false
      t.datetime :revoked_at
      t.string   :revoke_reason
      # "logout" | "password_change" | "admin_revoke" | "expired"
      t.string   :token_hmac, null: false
      t.timestamps
    end

    add_index :refresh_tokens, :token_hmac, unique: true
    add_index :refresh_tokens, :jti,          unique: true
    add_index :refresh_tokens, :token_digest, unique: true
    add_index :refresh_tokens, [ :user_id, :revoked_at ]
    add_index :refresh_tokens, :expires_at
  end
end
