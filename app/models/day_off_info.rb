class DayOffInfo < ApplicationRecord
  belongs_to :user
  has_one :day_off_category, as: :category
  validates :hours, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.create_day_off_info(day_off_info, user_id)
    day_off_info.each do |day_off|
      DayOffCategory.find(day_off.to_h['day_off_categories_id'])
      DayOffInfo.create! user_id: user_id, day_off_categories_id: day_off.to_h['day_off_categories_id'], hours: day_off.to_h['hours']
    end
  end
end
