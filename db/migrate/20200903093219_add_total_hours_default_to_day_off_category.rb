class AddTotalHoursDefaultToDayOffCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :day_off_categories, :total_hours_default, :integer
  end
end
