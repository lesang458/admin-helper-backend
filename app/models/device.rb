class Device < ApplicationRecord
  has_many :device_histories, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :device_category
  validates :name, presence: true, length: { in: 2..40 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :description, allow_nil: true, length: { minimum: 5 }

  def category_name
    device_category.name
  end

  def self.create_device(device_params, from_date)
    Device.transaction do
      User.find(device_params[:user_id]) if device_params[:user_id]
      device = Device.create!(device_params)
      DeviceHistory.create_device_history(from_date || Time.zone.now, device)
      device
    end
  end
end
