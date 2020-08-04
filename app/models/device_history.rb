class DeviceHistory < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :device
  validates :from_date, presence: true
  validate :validate_date_range
  enum status: { discarded: 'DISCARDED', assigned: 'ASSIGNED', in_inventory: 'IN_INVENTORY' }
  validates :status, presence: true, inclusion: { in: %w[discarded assigned in_inventory] }

  def self.create_device_history(from_date, device)
    device.device_histories.create! from_date: from_date, status: 'in_inventory'
  end

  private

  def validate_date_range
    errors.add(:from_date, "can't be in the to date") if to_date.present? && from_date.present? && to_date < from_date
  end
end
