class UpdateDevice < ActiveRecord::Migration[6.0]
  def change
    remove_index :devices, :device_category_id
  end
end
