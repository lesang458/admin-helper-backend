class DayOffInfo < ApplicationRecord
  belongs_to :user
  has_many :day_off_requests
  belongs_to :day_off_category
  validates :hours, presence: true, numericality: { only_integer: true, greater_than: 0 }
  delegate :email, :first_name, :last_name, to: :user
  delegate :category_name, :description, to: :day_off_category

  def available_hours
    hours - total_hours_of_request
  end

  def total_hours_of_request
    day_off_requests.sum(&:total_hours_off)
  end

  def self.create_day_off_info(day_off_info, user)
    day_off_info.each do |day_off|
      user.day_off_infos.create! day_off_category_id: day_off['day_off_category_id'], hours: day_off['hours']
    end
  end

  def category_name
    day_off_category.name
  end

  def self.search(params)
    day_off_infos = DayOffInfo.all
    day_off_infos = day_off_infos.where('user_id = ?', params[:user_id]) if params[:user_id].present?
    day_off_infos = day_off_infos.where('day_off_category_id = ?', params[:day_off_category_id]) if params[:day_off_category_id].present?
    day_off_infos
  end
end
