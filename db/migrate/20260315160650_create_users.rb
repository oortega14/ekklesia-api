class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.references :organization, foreign_key: true
      # null: true solo para super_admin

      t.string  :email,              null: false
      t.string  :password_digest,    null: false
      t.string  :first_name,         null: false
      t.string  :last_name,          null: false
      t.string  :phone
      t.string  :role,               null: false, default: "steward"
      # "super_admin" | "org_admin" | "pastor" | "steward"
      t.string  :avatar_url
      t.string  :timezone
      t.string  :locale,             default: "es"
      t.boolean :active,             null: false, default: true
      t.datetime :last_sign_in_at
      t.string   :last_sign_in_ip
      t.timestamps
    end

    add_index :users, :email,                        unique: true
    add_index :users, [ :organization_id, :role ]
    add_index :users, [ :organization_id, :active ]
  end
end
