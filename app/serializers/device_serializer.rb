class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :description, :user_id, :device_category_id, :device_category_name
end
