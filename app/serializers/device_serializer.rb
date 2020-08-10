class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :description, :device_category_id, :category_name, :user

  def user
    return unless object.user.present?
    {
      id: object.user_id,
      first_name: object.user.first_name,
      last_name: object.user.last_name,
      email: object.user.email
    }
  end
end
