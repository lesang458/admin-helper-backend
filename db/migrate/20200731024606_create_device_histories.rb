class CreateDeviceHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :device_histories do |t|
      t.datetime :from_date
      t.datetime :to_date
      t.string :status
      t.references :user, foreign_key: :true, on_delete: :cascade
      t.references :device, foreign_key: :true

      t.timestamps
    end
  end
end
