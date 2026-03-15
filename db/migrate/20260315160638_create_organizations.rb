class CreateOrganizations < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations do |t|
      t.string  :name,         null: false
      t.string  :slug,         null: false   # subdominio
      t.string  :logo_url
      t.string  :website
      t.string  :country_code, null: false, default: "CO"
      t.string  :default_currency, null: false, default: "COP"
      t.string  :default_timezone, null: false, default: "America/Bogota"
      t.string  :default_locale,   null: false, default: "es"
      t.string  :status,       null: false, default: "active"
      # "active" | "suspended" | "trial"
      t.date    :trial_ends_on
      t.jsonb   :settings,     null: false, default: {}
      t.timestamps
    end

    add_index :organizations, :slug,   unique: true
    add_index :organizations, :status
  end
end
