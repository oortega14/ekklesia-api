class CreateChurchPastors < ActiveRecord::Migration[8.1]
  def change
    create_table :church_pastors do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :church,       null: false, foreign_key: true
      t.references :user,         null: false, foreign_key: true

      t.string  :role_in_church, null: false, default: "associate"
      # "lead" | "associate" | "youth" | "worship" | "interim"
      t.date    :assigned_on,    null: false
      t.date    :released_on
      t.boolean :active,         null: false, default: true
      t.text    :notes
      t.timestamps
    end

    add_index :church_pastors, [ :church_id, :user_id ],
              unique: true, where: "active = true"
    add_index :church_pastors, [ :organization_id, :active ]
  end
end
