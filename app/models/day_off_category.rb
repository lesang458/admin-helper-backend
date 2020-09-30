class DayOffCategory < ApplicationRecord
  validates :name, uniqueness: true
  has_many :day_off_infos, dependent: :destroy
  has_many :day_off_requests, through: :day_off_infos
  enum status: { ACTIVE: 'ACTIVE', INACTIVE: 'INACTIVE' }
  validates :status, presence: true, inclusion: { in: %w[ACTIVE INACTIVE] }
  validates :name, presence: true, length: { in: 2..40 }
  validates :description, allow_nil: true, length: { minimum: 3 }
  validates :total_hours_default, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.search(status)
    DayOffCategory.where({ status: status.presence }.compact)
  end
end
