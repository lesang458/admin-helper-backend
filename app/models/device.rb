class Device < ApplicationRecord
  has_many :device_histories, dependent: :delete_all
  belongs_to :user, optional: true
  belongs_to :device_category
  validates :name, presence: true, length: { in: 2..40 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :description, allow_nil: true, length: { minimum: 5 }

  scope :with_status, ->(status) { joins(:device_histories).where('status = ? AND from_date < ? AND (to_date is null OR to_date > ?)', status, Date.today, Date.today) }
  def category_name
    device_category.name
  end

  def status
    device_histories.find_by('from_date <= ? AND (to_date is null OR to_date > ?)', Date.today, Date.today).status.upcase
  end

  def move_to_inventory
    update_status(nil, 'in_inventory')
  end

  def discard
    update_status(nil, 'discarded')
  end

  def update_status(user_id, status)
    Device.transaction do
      User.find(user_id) if user_id.present?
      update! user_id: user_id
      device_histories.last.update!(to_date: Time.zone.now)
      device_histories.create! from_date: Time.now, status: status, user_id: user_id
    end
  end

  def self.create_device(device_params, history_params)
    Device.transaction do
      User.find(device_params[:user_id]) if device_params[:user_id]
      device = Device.create!(device_params)
      device.device_histories.create! from_date: history_params[:from_date] || Time.zone.now, status: history_params[:status] || 'IN_INVENTORY'
      device
    end
  end

  def assign(user_id)
    update_status(user_id, 'assigned')
  end

  def self.search(params)
    devices = Device.all
    devices = devices.with_status(params[:status]) if params[:status].present?
    devices = devices.where('devices.user_id = ?', params[:user_id]) if params[:user_id].present?
    devices = devices.where('device_category_id = ?', params[:device_category_id]) if params[:device_category_id].present?
    devices
  end
end
