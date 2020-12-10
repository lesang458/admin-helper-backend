class AddSalaryPerMonthToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :salary_per_month, :float, default: 0.0
  end
end
