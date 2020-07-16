class DayOffRequest < ApplicationRecord
  belongs_to :day_off_info
  belongs_to :user
  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :hours_per_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
  delegate :email, :first_name, :last_name, to: :user

  scope :to_date, ->(to) { where('from_date <= ? OR to_date <= ?', to, to) if to }
  scope :from_date, ->(from) { where('from_date >= ? OR to_date >= ?', from, from) if from }

  def self.search(params)
    day_off_request = DayOffRequest.joins("INNER JOIN day_off_infos ON day_off_infos.id = day_off_requests.day_off_info_id
      INNER JOIN day_off_categories ON day_off_categories.id = day_off_infos.day_off_category_id")
    day_off_request = day_off_request.where("day_off_categories.id = #{params[:day_off_category_id]}") if params[:day_off_category_id]
    day_off_request = day_off_request.to_date(params[:to_date])
    day_off_request = day_off_request.from_date(params[:from_date])
    day_off_request
  end
end
