class DayOffRequest < ApplicationRecord
  belongs_to :day_off_info
  belongs_to :user
  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :hours_per_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
  delegate :email, :first_name, :last_name, to: :user

  scope :from_date, ->(to) { where('from_date <= ?', to) if to }
  scope :to_date, ->(from) { where('to_date >= ?', from) if from }

  def self.search(params)
    DayOffRequest.includes(day_off_info: :day_off_category).from_date(params[:to_date]).to_date(params[:from_date])
  end
end
