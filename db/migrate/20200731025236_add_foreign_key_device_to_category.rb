class AddForeignKeyDeviceToCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :device_category_id, :bigint
    add_index :devices, :device_category_id, unique: true
    add_foreign_key :devices, :device_categories, null: false, on_delete: :cascade

    remove_foreign_key :devices, :users
    add_foreign_key :devices, :users, on_delete: :cascade
  end
end
