class AddEmployeeFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthdate, :date
    add_column :users, :join_date, :date
    add_column :users, :status, :string, default: "ACTIVE"
    add_column :users, :phone_number, :string
  end
end
