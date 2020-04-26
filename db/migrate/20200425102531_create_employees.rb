class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.date :birthday
      t.date :joined_company_date
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :employees, [:user_id, :created_at]
  end
end
