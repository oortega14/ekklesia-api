class CreateOfferingReports < ActiveRecord::Migration[8.1]
  def change
    create_table :offering_reports do |t|
      t.references :organization,  null: false, foreign_key: true
      t.references :service,       null: false, foreign_key: true
      t.references :submitted_by,
                   null: false, foreign_key: { to_table: :users }
      t.references :responsible_pastor,
                   foreign_key: { to_table: :users },
                   index: true
      t.references :approved_by,
                   foreign_key: { to_table: :users },
                   index: true

      t.string   :currency,            null: false, default: "COP"
      t.decimal  :tithes,              precision: 14, scale: 2, default: 0
      t.decimal  :offerings,           precision: 14, scale: 2, default: 0
      t.decimal  :special_offerings,   precision: 14, scale: 2, default: 0
      t.decimal  :missions_fund,       precision: 14, scale: 2, default: 0
      t.decimal  :total,               precision: 14, scale: 2, null: false
      t.jsonb    :breakdown,           null: false, default: {}
      # { "Fondo construcción": 500000, "Niños": 200000 }
      t.text     :notes
      t.string   :status,              null: false, default: "draft"
      t.datetime :submitted_at
      t.datetime :approved_at
      t.timestamps
    end

    add_index :offering_reports, :service_id, unique: true
    add_index :offering_reports, [ :organization_id, :status ]
    add_index :offering_reports, :submitted_at
  end
end
