class DeviceHistorySerializer < ActiveModel::Serializer
  belongs_to :user, optional: true
  belongs_to :device
  attributes :id, :from_date, :to_date, :status, :user, :device

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
  end

  class DeviceSerializer < ActiveModel::Serializer
    attributes :id, :name, :price, :description
  end
end
