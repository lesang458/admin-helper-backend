class DayOffRequestSerializer < ActiveModel::Serializer
  attributes :email, :first_name, :last_name, :from_date, :to_date, :hours_per_day, :notes
end
