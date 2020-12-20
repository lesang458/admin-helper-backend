class AddPositionToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :positon, :string, default: "JUNIOR_DEV"
  end
end
