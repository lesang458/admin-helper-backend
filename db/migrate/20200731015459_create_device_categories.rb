class CreateDeviceCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :device_categories do |t|
      t.string :name
      t.text :description
    end
  end
end
