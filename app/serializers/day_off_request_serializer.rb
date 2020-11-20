class DayOffRequestSerializer < ActiveModel::Serializer
  belongs_to :day_off_category
  belongs_to :user
  attributes :id, :from_date, :to_date, :hours_per_day, :notes, :status
  class DayOffCategorySerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :total_hours_default, :status
  end
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :first_name, :last_name
  end
end
