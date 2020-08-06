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

  def self.create_device(device_params, history_params)
    Device.transaction do
      User.find(device_params[:user_id]) if device_params[:user_id]
      device = Device.create!(device_params)
      device.device_histories.create! from_date: history_params[:from_date] || Time.zone.now, status: history_params[:status] || 'IN_INVENTORY'
      device
    end
  end

  def self.search(params)
    devices = Device.all
    devices = Device.joins(:device_histories).where('status = ?', params[:status]) if params[:status].present?
    devices = devices.where('device_histories.user_id = ?', params[:user_id]) if params[:user_id].present?
    devices = devices.where('device_category_id = ?', params[:device_category_id]) if params[:device_category_id].present?
    devices
  end
end
