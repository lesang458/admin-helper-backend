class DeviceHistory < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :device
  validates :from_date, presence: true
  validate :validate_date_range
  enum status: { discarded: 'DISCARDED', assigned: 'ASSIGNED', inventory: 'INVENTORY' }
  validates :status, presence: true, inclusion: { in: %w[discarded assigned inventory] }

  private

  def validate_date_range
    errors.add(:from_date, "can't be in the to date") if to_date.present? && from_date.present? && to_date < from_date
  end
end
