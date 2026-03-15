class CreateChurches < ActiveRecord::Migration[8.1]
  def change
    create_table :churches do |t|
      t.timestamps
    end
  end
end
