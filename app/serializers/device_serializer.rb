class DeviceSerializer < ActiveModel::Serializer
  belongs_to :user, optional: true
  attributes :id, :name, :price, :description, :status_device, :device_category_id, :category_name, :user

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :email
  end
end
