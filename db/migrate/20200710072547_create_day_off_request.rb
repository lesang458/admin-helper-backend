class CreateDayOffRequest < ActiveRecord::Migration[6.0]
  def change
    create_table :day_off_requests do |t|
      t.datetime    :from_date
      t.datetime    :to_date
      t.integer     :hours_per_day
      t.text        :notes
      t.references  :day_off_info, foreign_key: true
      t.references  :user, foreign_key: :true
      t.timestamps
    end
  end
end
