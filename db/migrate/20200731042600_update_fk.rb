class UpdateFk < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :day_off_requests, :day_off_infos
    add_foreign_key :day_off_requests, :day_off_infos, on_delete: :cascade

    remove_foreign_key :day_off_requests, :users
    add_foreign_key :day_off_requests, :users, on_delete: :cascade
  end
end
