class Employee < ApplicationRecord
  belongs_to :user, dependent: :destroy
  validates :first_name, presence: :true, length: { in: 2..75 }
  validates :last_name, presence: :true, length: { in: 2..75 }
  enum status: { ACTIVE: "ACTIVE", FORMER: "FORMER" }
  validates :status, presence: :true, inclusion: { in: %w(ACTIVE FORMER) }
end
