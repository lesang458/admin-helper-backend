class UpdateForeignKey < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :device_histories, :users
    add_foreign_key :device_histories, :users, on_delete: :cascade

    remove_foreign_key :device_histories, :devices
    add_foreign_key :device_histories, :devices, on_delete: :cascade

  end
end
