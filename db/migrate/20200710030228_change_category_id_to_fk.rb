class ChangeCategoryIdToFk < ActiveRecord::Migration[6.0]
  def change
    remove_column :day_off_infos, :day_off_category_id
    add_reference :day_off_infos, :day_off_categories, index: true
  end
end
