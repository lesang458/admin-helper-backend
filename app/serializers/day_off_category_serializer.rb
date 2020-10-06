class DayOffCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :total_hours_default, :status, :description
end
