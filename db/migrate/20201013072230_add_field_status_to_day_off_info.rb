class AddFieldStatusToDayOffInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :day_off_infos, :status, :string, default: 'ACTIVE'
  end
end
