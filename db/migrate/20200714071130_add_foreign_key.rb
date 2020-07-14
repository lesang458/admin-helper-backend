class AddForeignKey < ActiveRecord::Migration[6.0]
  def change
    rename_column :day_off_infos, :day_off_categories_id, :day_off_category_id
    add_foreign_key :day_off_infos, :day_off_categories, null: false, on_delete: :cascade
  end
end
