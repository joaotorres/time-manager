class AddContactCenterRefToTimeSchedule < ActiveRecord::Migration[5.2]
  def change
    add_reference :time_schedules, :contact_center, foreign_key: true
  end
end
