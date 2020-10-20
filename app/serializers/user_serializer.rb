class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :birthdate, :join_date, :status, :day_off_infos, :phone_number, :roles
  class DayOffInfoSerializer < ActiveModel::Serializer
    attributes :day_off_category_id, :hours, :category_name, :available_hours, :status
  end

  def day_off_infos
    object.active_day_off_infos.map { |info| DayOffInfoSerializer.new info }
  end
end
