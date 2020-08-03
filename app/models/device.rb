class Device < ApplicationRecord
  has_many :device_histories, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :device_category
  validates :name, presence: true, length: { in: 2..40 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :description, allow_nil: true, length: { minimum: 5 }
  delegate :device_category_name, to: :device_category

  def device_category_name
    device_category.name
  end
end
