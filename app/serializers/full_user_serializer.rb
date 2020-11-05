class FullUserSerializer < ActiveModel::Serializer
  has_many :day_off_infos
  attributes :id, :email, :first_name, :last_name, :day_off_infos, :birthdate, :join_date, :status, :phone_number, :roles
  class DayOffInfoSerializer < ActiveModel::Serializer
    attributes :day_off_category_id, :hours, :category_name, :available_hours, :status
  end
end
