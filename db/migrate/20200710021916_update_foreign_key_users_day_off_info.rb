class UpdateForeignKeyUsersDayOffInfo < ActiveRecord::Migration[6.0]
  def change
    # remove the old foreign_key
    remove_foreign_key :day_off_infos, :users

    # add the new foreign_key
    add_foreign_key :day_off_infos, :users, on_delete: :cascade
  end
end
