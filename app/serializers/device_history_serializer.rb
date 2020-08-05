class DeviceHistorySerializer < ActiveModel::Serializer
  attributes :id, :from_date, :to_date, :status, :user, :device

  def user
    return unless object.user.present?
    {
      full_name: object.user.first_name + ' ' + object.user.last_name,
      email: object.user.email
    }
  end

  def device
    {
      name: object.device.name,
      price: object.device.price,
      description: object.device.description
    }
  end
end
