class DayOffRequestSerializer < ActiveModel::Serializer
  belongs_to :day_off_category
  attributes :id, :email, :first_name, :last_name, :from_date, :to_date, :hours_per_day, :notes
  class DayOffCategorySerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :total_hours_default, :status
  end
end
