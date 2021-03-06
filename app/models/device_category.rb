class DeviceCategory < ApplicationRecord
  after_commit :flush_cache!
  has_many :devices, dependent: :destroy
  validates :name, presence: true

  def self.all_categories
    Rails.cache.fetch('all_device_categories', expires_in: 1.day) { DeviceCategory.order(id: :asc) }
  end

  private

  def flush_cache!
    Rails.cache.delete 'all_device_categories'
  end
end
