class DayOffInfoSerializer < ActiveModel::Serializer
  attributes :id, :hours, :day_off_category_id, :name, :description, :user_id, :email, :first_name, :last_name
end
