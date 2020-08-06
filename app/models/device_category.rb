class DeviceCategory < ApplicationRecord
  after_commit :flush_cache!
  has_many :devices, dependent: :destroy
  validates :name, presence: true

  def self.by_all_device_categories
    Rails.cache.fetch('all_device_categories') { DeviceCategory.all }
  end

  private

  def flush_cache!
    Rails.cache.delete 'all_device_categories'
  end
end
