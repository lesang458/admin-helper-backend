class DayOffRequestSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :from_date, :to_date, :hours_per_day, :notes, :day_off_category
end
