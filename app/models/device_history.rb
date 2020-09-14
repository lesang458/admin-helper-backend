class DeviceHistory < ApplicationRecord
  ACTION_RULES = {
    'assigned' => %w[assigned in_inventory discarded],
    'discarded' => %w[],
    'in_inventory' => %w[assigned discarded]
  }.freeze
  belongs_to :user, optional: true
  belongs_to :device
  validates :from_date, presence: true
  validate :validate_date_range
  enum status: { discarded: 'DISCARDED', assigned: 'ASSIGNED', in_inventory: 'IN_INVENTORY' }
  validates :status, presence: true, inclusion: { in: %w[discarded assigned in_inventory] }
  scope :to_date, ->(to) { where('from_date <= ? OR to_date <= ?', to, to) if to }
  scope :from_date, ->(from) { where('from_date >= ? OR to_date >= ?', from, from) if from }
  validate :allow_action?, on: :create
  # rubocop:disable Metrics/AbcSize
  def self.search(params)
    device_histories = DeviceHistory.all
    device_histories = DeviceHistory.joins(:device).where('device_category_id = ?', params[:device_category_id]) if params[:device_category_id].present?
    device_histories = device_histories.where('status = ?', params[:status]) if params[:status].present?
    device_histories = device_histories.to_date(params[:history_to]) if params[:history_to].present?
    device_histories = device_histories.from_date(params[:history_from]) if params[:history_from].present?
    device_histories = device_histories.where('device_histories.user_id = ?', params[:user_id]) if params[:user_id].present?
    device_histories = device_histories.where('device_id = ?', params[:device_id]) if params[:device_id].present?
    device_histories
  end
  # rubocop:enable Metrics/AbcSize

  private

  def validate_date_range
    errors.add(:from_date, "can't be in the to date") if to_date.present? && from_date.present? && to_date < from_date
  end

  def allow_action?
    errors.add(:status, 'is not valid') unless valid_status?
  end

  def valid_status?
    return true if device&.device_histories.blank?
    ACTION_RULES[device.status.downcase].include?(status)
  end
end
