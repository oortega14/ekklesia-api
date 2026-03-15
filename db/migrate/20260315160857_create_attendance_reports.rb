class CreateAttendanceReports < ActiveRecord::Migration[8.1]
  def change
    create_table :attendance_reports do |t|
      t.references :organization,  null: false, foreign_key: true
      t.references :service,       null: false, foreign_key: true, index: { unique: true }
      t.references :submitted_by,
                   null: false, foreign_key: { to_table: :users }
      t.references :responsible_pastor,
                   foreign_key: { to_table: :users },
                   index: true
      # populated solo cuando submitted_by es un steward
      t.references :approved_by,
                   foreign_key: { to_table: :users },
                   index: true

      t.integer  :total_attendees,  null: false
      t.integer  :men
      t.integer  :women
      t.integer  :children                      # < 12 años
      t.integer  :youth                         # 13–25 años
      t.integer  :adults
      t.integer  :seniors
      t.integer  :new_visitors,     default: 0
      t.integer  :first_time,       default: 0
      t.integer  :members
      t.integer  :online_viewers,   default: 0
      t.text     :notes
      t.string   :status,           null: false, default: "draft"
      # "draft" | "submitted" | "approved" | "rejected"
      t.datetime :submitted_at
      t.datetime :approved_at
      t.timestamps
    end

    add_index :attendance_reports, [ :organization_id, :status ]
    add_index :attendance_reports, :submitted_at
  end
end
