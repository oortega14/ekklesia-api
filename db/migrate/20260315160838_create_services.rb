class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :church,       null: false, foreign_key: true
      t.references :created_by,
                   null: false, foreign_key: { to_table: :users }

      t.string   :name,           null: false
      t.string   :service_type,   null: false, default: "sunday"
      # "sunday" | "midweek" | "youth" | "special" | "online"
      t.datetime :scheduled_at,   null: false
      t.integer  :duration_minutes, default: 90
      t.string   :status,         null: false, default: "scheduled"
      # "scheduled" | "completed" | "cancelled"
      t.text     :description
      t.string   :location_note
      t.timestamps
    end

    add_index :services, [ :organization_id, :church_id, :scheduled_at ]
    add_index :services, [ :organization_id, :status ]
    add_index :services, :service_type
  end
end
