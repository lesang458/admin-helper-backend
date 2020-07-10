class DayOffInfo < ApplicationRecord
  belongs_to :user
  has_many :day_off_request
  has_one :day_off_category, as: :category
  validates :hours, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
