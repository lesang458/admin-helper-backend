class AddStatusToDayOffRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :day_off_requests, :status, :string
  end
end
