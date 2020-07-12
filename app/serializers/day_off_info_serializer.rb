class DayOffInfoSerializer < ActiveModel::Serializer
  attributes :day_off_categories_id, :hours, :user_id
end
