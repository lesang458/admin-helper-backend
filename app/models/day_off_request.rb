class DayOffRequest < ApplicationRecord
  belongs_to :day_off_info
  belongs_to :user
  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :hours_per_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :validate_date_range
  validate :validate_info_user
  delegate :email, :first_name, :last_name, to: :user
  delegate :day_off_category, to: :day_off_info
  validate :request_too_long
  validate :check_category_status, on: :create

  scope :to_date, ->(to) { where('from_date <= ? OR to_date <= ?', to, to) if to }
  scope :from_date, ->(from) { where('from_date >= ? OR to_date >= ?', from, from) if from }

  def total_hours_off
    (to_date.to_date - from_date.to_date + 1).to_i * hours_per_day
  end

  def self.search(params)
    day_off_request = DayOffRequest.all
    day_off_request = DayOffCategory.find(params[:day_off_category_id]).day_off_requests if params[:day_off_category_id]
    day_off_request = day_off_request.where('day_off_requests.user_id = ?', params[:id])
    day_off_request.to_date(params[:to_date]).from_date(params[:from_date])
  end

  def self.create_requests(params, user_id)
    employee = User.find(user_id)
    day_off_request = employee.day_off_requests.new(params)
    day_off_request.save!
    day_off_request.different_year_request? ? [day_off_request, day_off_request.next_year_request] : [day_off_request]
  end

  def different_year_request?
    different_year = to_date.to_datetime.year - from_date.to_datetime.year if from_date.present? && to_date.present?
    different_year.positive?
  end

  def next_year_request
    next_year_request = self.dup
    update! to_date: from_date.to_datetime.end_of_year
    next_year_request.from_date = from_date.to_datetime.end_of_year + 1
    next_year_request.save!
    next_year_request
  end

  private

  def check_category_status
    errors[:base] << 'Day off category inactivated' if day_off_info.day_off_category.inactive?
  end

  def validate_info_user
    return unless day_off_info.present?
    errors.add(:day_off_info, 'user is not the same as requested user') unless user.day_off_infos.ids.include?(day_off_info.id)
  end

  def validate_date_range
    errors.add(:from_date, "can't be after To date") if to_date.present? && from_date.present? && to_date < from_date
  end

  def request_too_long
    errors[:base] << 'Request is too long' if to_date.present? && from_date.present? && to_date.to_datetime.year - from_date.to_datetime.year > 1
  end
end
