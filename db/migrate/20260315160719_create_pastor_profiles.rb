class CreatePastorProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :pastor_profiles do |t|
      t.timestamps
    end
  end
end
