class DeviceHistorySerializer < ActiveModel::Serializer
  attributes :id, :from_date, :to_date, :status, :email, :first_name, :last_name, :name, :price, :description
end
