class DayOffInfo < ApplicationRecord
  belongs_to :user
  validates :hours, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :day_off_category_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
