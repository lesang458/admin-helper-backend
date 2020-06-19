class AddRolesToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :roles, :string, array: true, default: '{EMPLOYEE}'
  end
end
