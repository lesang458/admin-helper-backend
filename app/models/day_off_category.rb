class DayOffCategory < ApplicationRecord
  validates :name, uniqueness: true
  has_many :day_off_infos, dependent: :destroy
  has_many :day_off_requests, through: :day_off_infos
  enum name: { VACATION: 'VACATION', ILLNESS: 'ILLNESS' }
  validates :name, presence: true, inclusion: { in: %w[VACATION ILLNESS] }
  enum status: { ACTIVE: 'ACTIVE', INACTIVE: 'INACTIVE' }
  validates :status, presence: true, inclusion: { in: %w[ACTIVE INACTIVE] }
  validates :description, allow_nil: true, length: { minimum: 3 }
  validates :total_hours_default, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.search(params_status)
    day_off_categories = DayOffCategory.all
    day_off_categories.where('status = ?', params_status) if params_status
    day_off_categories
  end
end
