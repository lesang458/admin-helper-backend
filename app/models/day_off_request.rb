class DayOffRequest < ApplicationRecord
  belongs_to :day_off_info
  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :hours_per_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
