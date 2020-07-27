class DayOffInfo < ApplicationRecord
  belongs_to :user
  has_many :day_off_requests
  belongs_to :day_off_category
  validates :hours, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def available_hours
    self.hours - total_hours_of_request
  end

  def total_hours_of_request
    self.day_off_requests.sum(&:total_hours_off)
  end

  def self.create_day_off_info(day_off_info, user)
    day_off_info.each do |day_off|
      user.day_off_infos.create! day_off_category_id: day_off['day_off_category_id'], hours: day_off['hours']
    end
  end
end
