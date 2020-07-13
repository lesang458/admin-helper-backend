class DayOffRequest < ApplicationRecord
  belongs_to :day_off_info
  belongs_to :user
  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :hours_per_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
  delegate :email, :first_name, :last_name, to: :user
end
