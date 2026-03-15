class CreateOfferingReports < ActiveRecord::Migration[8.1]
  def change
    create_table :offering_reports do |t|
      t.timestamps
    end
  end
end
