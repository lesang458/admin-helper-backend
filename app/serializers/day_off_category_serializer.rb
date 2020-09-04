class DayOffCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :total_hours_default, :description
end
