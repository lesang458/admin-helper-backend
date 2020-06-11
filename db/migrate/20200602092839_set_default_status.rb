class SetDefaultStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :employees, :status, :string, default: "ACTIVE"
  end
end
