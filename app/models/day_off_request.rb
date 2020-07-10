class DayOffRequest < ApplicationRecord
  belongs_to :day_off_info
  validates :hours_per_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
