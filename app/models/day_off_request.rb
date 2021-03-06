class DayOffRequest < ApplicationRecord
  belongs_to :day_off_info, optional: true
  belongs_to :user
  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :hours_per_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :validate_date_range
  validate :validate_info_user
  delegate :email, :first_name, :last_name, to: :user
  delegate :day_off_category, to: :day_off_info, allow_nil: true
  validate :request_too_long
  validate :check_category_status, on: :create
  enum status: { pending: 'pending', approved: 'approved', denied: 'denied', cancelled: 'cancelled' }
  validates :status, presence: true, inclusion: { in: %w[pending approved denied cancelled] }

  scope :to_date, ->(to) { where('from_date <= ? OR to_date <= ?', to, to) if to }
  scope :from_date, ->(from) { where('from_date >= ? OR to_date >= ?', from, from) if from }
  scope :requests_by_employee_name, ->(employee_name) { where user_id: User.employee_name_like(employee_name).pluck(:id) }

  ACTION_TO_STATUS = { 'deny' => 'denied', 'approve' => 'approved' }.freeze
  def total_hours_off
    business_days_between(from_date.to_date, to_date.to_date) * hours_per_day
  end

  def business_days_between(date1, date2)
    business_days = 0
    date = date2
    while date >= date1
     business_days = business_days + 1 unless date.saturday? or date.sunday?
     date = date - 1.day
    end
    business_days
  end

  # rubocop:disable Metrics/AbcSize
  def self.search(params)
    day_off_requests = DayOffCategory.find(params[:day_off_category_id]).reorder(id: :desc).day_off_requests if params[:day_off_category_id]
    day_off_requests = (day_off_requests || DayOffRequest.order(id: :desc)).where({ user_id: params[:user_id].presence }.compact)
    day_off_requests = day_off_requests.where('day_off_requests.status = :search', search: params[:status]) if params[:status]
    day_off_requests = day_off_requests.requests_by_employee_name(params[:employee_name]) if params[:employee_name]
    day_off_requests.to_date(params[:to_date]).from_date(params[:from_date])
  end
  # rubocop:enable Metrics/AbcSize

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

  def separate_request
    self.different_year_request? ? [self, self.next_year_request] : [self]
  end

  def send_request(action)
    raise(ExceptionHandler::BadRequest, "Something went wrong when trying to #{action} day_off_request") unless pending?
    DayOffRequest.transaction do
      self.status = ACTION_TO_STATUS[action]
      self.save!
      UserMailer.notify_requested_employee(self, "#{self.status.capitalize} request").deliver_now
    end
  end

  private

  def check_category_status
    errors[:base] << 'Day off category inactivated' if day_off_info&.day_off_category&.inactive?
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
