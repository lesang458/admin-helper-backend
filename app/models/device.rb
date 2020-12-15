class Device < ApplicationRecord
  has_many :device_histories, dependent: :delete_all
  belongs_to :user, optional: true
  belongs_to :device_category
  validates :name, presence: true, length: { in: 2..40 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :description, allow_nil: true, length: { minimum: 5 }

  scope :with_status, ->(status) { joins(:device_histories).where('status = ? AND from_date < ? AND (to_date is null OR to_date > ?)', status, Time.now, Time.now) }
  def category_name
    device_category.name
  end

  def status
    device_histories.where('from_date <= ? AND (to_date is null OR to_date > ?)', Time.now, Time.now).last&.status&.upcase
  end

  def move_to_inventory
    update_status(nil, 'in_inventory')
  end

  def discard
    update_status(nil, 'discarded')
  end

  def update_status(new_user_id, new_status)
    Device.transaction do
      User.find(new_user_id) if new_user_id.present?
      update! user_id: new_user_id
      now = Time.zone.now
      old_history = device_histories.find_by to_date: nil
      raise(ExceptionHandler::BadRequest, 'Something went wrong when trying to update status device') unless old_history
      device_histories.create! from_date: now, status: new_status, user_id: new_user_id
      old_history.update!(to_date: now)
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

  def assign(new_user_id)
    raise(ExceptionHandler::BadRequest, 'Device has been assigned to the user') if user_id == new_user_id
    update_status(new_user_id, 'assigned')
  end

  def self.search(params)
    devices = Device.order(id: :asc)
    devices = devices.with_status(params[:status]) if params[:status].present?
    devices = devices.where('devices.user_id = ?', params[:user_id]) if params[:user_id].present?
    devices = devices.where('device_category_id = ?', params[:device_category_id]) if params[:device_category_id].present?
    devices
  end
end
