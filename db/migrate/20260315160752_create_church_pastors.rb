class CreateChurchPastors < ActiveRecord::Migration[8.1]
  def change
    create_table :church_pastors do |t|
      t.timestamps
    end
  end
end
