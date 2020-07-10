class CreateDayOffCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :day_off_categories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
