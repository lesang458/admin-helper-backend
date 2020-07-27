class DayOffRequest < ApplicationRecord
  belongs_to :day_off_info
  belongs_to :user
  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :hours_per_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :validate_date_range
  delegate :email, :first_name, :last_name, to: :user
  delegate :day_off_category, to: :day_off_info

  scope :to_date, ->(to) { where('from_date <= ? OR to_date <= ?', to, to) if to }
  scope :from_date, ->(from) { where('from_date >= ? OR to_date >= ?', from, from) if from }

  def total_hours_off
    (to_date.to_date - from_date.to_date + 1).to_i * hours_per_day
  end

  def self.search(params)
    day_off_request = DayOffRequest.all
    day_off_request = DayOffCategory.find(params[:day_off_category_id]).day_off_requests if params[:day_off_category_id]
    day_off_request = day_off_request.where('day_off_requests.user_id = ?', params[:id])
    day_off_request = day_off_request.to_date(params[:to_date])
    day_off_request = day_off_request.from_date(params[:from_date])
    day_off_request
  end

  private

  def validate_date_range
    errors.add(:from_date, "can't be in the to date") if to_date.present? && from_date.present? && to_date < from_date
  end
end
