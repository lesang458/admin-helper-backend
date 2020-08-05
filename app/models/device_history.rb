class DeviceHistory < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :device
  validates :from_date, presence: true
  validate :validate_date_range
  enum status: { discarded: 'DISCARDED', assigned: 'ASSIGNED', inventory: 'INVENTORY' }
  validates :status, presence: true, inclusion: { in: %w[discarded assigned inventory] }
  delegate :devices, to: :device

  scope :to_date, ->(to) { where('from_date <= ? OR to_date <= ?', to, to) if to }
  scope :from_date, ->(from) { where('from_date >= ? OR to_date >= ?', from, from) if from }

  # rubocop:disable Metrics/AbcSize
  def self.search(params)
    device_histories = DeviceHistory.all
    device_histories = DeviceHistory.joins(:device).where('device_category_id = ?', params[:device_category_id]) if params[:device_category_id].present?
    device_histories = device_histories.where('status = ?', params[:status]) if params[:status].present?
    device_histories = device_histories.to_date(params[:history_to]) if params[:history_to].present?
    device_histories = device_histories..from_date(params[:history_from]) if params[:history_from].present?
    device_histories = device_histories.where('user_id = ?', params[:user_id]) if params[:user_id].present?
    device_histories = device_histories.where('device_id = ?', params[:device_id]) if params[:device_id].present?
    device_histories
  end
  # rubocop:enable Metrics/AbcSize

  private

  def validate_date_range
    errors.add(:from_date, "can't be in the to date") if to_date.present? && from_date.present? && to_date < from_date
  end
end
