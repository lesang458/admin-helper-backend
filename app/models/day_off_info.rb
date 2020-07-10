class DayOffInfo < ApplicationRecord
  belongs_to :user
  has_one :day_off_category
  validates :hours, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
