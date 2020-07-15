class DayOffInfo < ApplicationRecord
  belongs_to :user
  has_many :day_off_requests
  belongs_to :day_off_category, class_name: 'DayOffCategory'
  validates :hours, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
