class CreateDayOffInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :day_off_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :day_off_category_id
      t.integer :hours

      t.timestamps
    end
  end
end
