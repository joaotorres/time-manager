class CreateTimeSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :time_schedules do |t|
      t.string :day
      t.time :period_start
      t.time :period_end
      t.string :timezone
      t.boolean :closed

      t.timestamps
    end
  end
end
