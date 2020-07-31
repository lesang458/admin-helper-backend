class DeviceCategory < ApplicationRecord
  has_many :devices, dependent: :destroy
  validates :name, presence: true
end
