class AddCertificateToUser < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :certificate, :string, default: "UNIVERSITY"
  end
end
