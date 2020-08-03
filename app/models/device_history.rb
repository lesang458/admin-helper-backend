class DeviceHistory < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :device
  validates :from_date, presence: true
  enum status: { DISCARDED: 'DISCARDED', ASSIGNED: 'ASSIGNED', INVENTORY: 'INVENTORY' }
  validates :status, presence: true, inclusion: { in: %w[DISCARDED ASSIGNED INVENTORY] }
end
