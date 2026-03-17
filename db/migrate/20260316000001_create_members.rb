class CreateMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :members do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :church, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :phone
      t.string :role, default: "member", null: false
      t.string :status, default: "active", null: false
      t.date :joined_on
      t.string :avatar_url

      t.timestamps
    end

    add_index :members, [ :organization_id, :status ]
    add_index :members, [ :organization_id, :church_id ]
    add_index :members, :email
  end
end
