class DayOffCategory < ApplicationRecord
  validates :name, uniqueness: true
  enum name: { VACATION: 'VACATION', ILLNESS: 'ILLNESS' }
  validates :name, presence: true, inclusion: { in: %w[VACATION ILLNESS] }
  validates :description, allow_nil: true, length: { minimum: 3 }
end
