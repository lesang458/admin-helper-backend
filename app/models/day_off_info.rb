class DayOffInfo < ApplicationRecord
  belongs_to :user
  has_many :day_off_requests
  belongs_to :day_off_category
  enum status: { active: 'ACTIVE', inactive: 'INACTIVE' }
  validates :status, presence: true, inclusion: { in: %w[active inactive] }
  validates :hours, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  delegate :email, :first_name, :last_name, to: :user
  delegate :category_name, :description, to: :day_off_category

  def self.id_by_user_and_category(user_id, day_off_category_id)
    info = find_by('day_off_category_id = ? AND user_id = ?', day_off_category_id, user_id)
    raise(ArgumentError, 'Invalid category or user') unless info

    info.id
  end

  def available_hours
    hours - total_hours_of_request
  end

  def total_hours_of_request
    day_off_requests.sum(&:total_hours_off)
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
