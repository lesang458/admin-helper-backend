class Device < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { in: 2..40 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :description, allow_nil: true, length: { minimum: 5 }
end
