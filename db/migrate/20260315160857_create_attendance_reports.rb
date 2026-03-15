class CreateAttendanceReports < ActiveRecord::Migration[8.1]
  def change
    create_table :attendance_reports do |t|
      t.timestamps
    end
  end
end
