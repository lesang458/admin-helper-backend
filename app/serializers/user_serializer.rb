class UserSerializer < ActiveModel::Serializer
  has_many :day_off_infos
  attributes :id, :email, :first_name, :last_name, :birthdate, :join_date, :status, :phone_number, :day_off_infos, :roles
  class DayOffInfoSerializer < ActiveModel::Serializer
    attributes :day_off_category_id, :hours, :category_name, :available_hours
  end
end
