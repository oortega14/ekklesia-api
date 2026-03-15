class CreateChurches < ActiveRecord::Migration[8.1]
  def change
    create_table :churches do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :lead_pastor,
                   foreign_key: { to_table: :users },
                   index: true

      t.string  :name,          null: false
      t.string  :code                          # "BOG-01"
      t.string  :status,        null: false, default: "active"
      # "active" | "inactive" | "plant"
      t.string  :country_code,  null: false
      t.string  :city
      t.string  :state_province
      t.text    :address_line
      t.decimal :latitude,  precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.string  :timezone,      default: "America/Bogota"
      t.string  :phone
      t.string  :email
      t.date    :founded_on
      t.integer :capacity
      t.jsonb   :settings, null: false, default: {}
      t.timestamps
    end

    add_index :churches, [ :organization_id, :code ], unique: true,
              where: "code IS NOT NULL"
    add_index :churches, [ :organization_id, :status ]
    add_index :churches, [ :latitude, :longitude ]
  end
end
