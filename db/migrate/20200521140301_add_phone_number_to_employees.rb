class AddPhoneNumberToEmployees < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :phone_number, :string
  end
end
