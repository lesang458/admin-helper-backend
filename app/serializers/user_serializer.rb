class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :birthdate, :join_date, :status, :phone_number, :day_off_infos, :roles

  def day_off_infos
    return unless object.day_off_infos.present?
    object.day_off_infos.map { |info| { category: info.day_off_category.name, hours: info.hours, available_hours: info.available_hours } }
  end
end
