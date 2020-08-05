class DeviceHistory < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :device
  validates :from_date, presence: true
  validate :validate_date_range
  enum status: { DISCARDED: 'DISCARDED', ASSIGNED: 'ASSIGNED', IN_INVENTORY: 'IN_INVENTORY' }
  validates :status, presence: true, inclusion: { in: %w[DISCARDED ASSIGNED IN_INVENTORY] }

  private

  def validate_date_range
    errors.add(:from_date, "can't be in the to date") if to_date.present? && from_date.present? && to_date < from_date
  end
end
