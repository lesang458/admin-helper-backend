class AddFieldStatusToDayOffCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :day_off_categories, :status, :string
  end
end
