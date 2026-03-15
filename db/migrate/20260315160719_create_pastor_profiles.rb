class CreatePastorProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :pastor_profiles do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user,         null: false, foreign_key: true

      t.text    :bio
      t.date    :ordained_on
      t.string  :ordaining_body
      t.string  :specialties,  array: true, default: []
      t.string  :languages,    array: true, default: [ "es" ]
      t.boolean :available_for_transfer, default: false
      t.timestamps
    end

    add_index :pastor_profiles, :user_id, unique: true
    add_index :pastor_profiles, :organization_id
  end
end
