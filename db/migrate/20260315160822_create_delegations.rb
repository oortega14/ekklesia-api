class CreateDelegations < ActiveRecord::Migration[8.1]
  def change
    create_table :delegations do |t|
      t.timestamps
    end
  end
end
