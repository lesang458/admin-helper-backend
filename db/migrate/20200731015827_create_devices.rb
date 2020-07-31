class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :name
      t.integer :price
      t.text :description
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
