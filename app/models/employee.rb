class Employee < ApplicationRecord
  DEFAULTPASSWORD = '123456'.freeze
  belongs_to :user
  validates :first_name, presence: true, length: { in: 2..20 }
  validates :last_name, presence: true, length: { in: 2..20 }
  enum status: { ACTIVE: 'ACTIVE', FORMER: 'FORMER' }
  validates :status, presence: true, inclusion: { in: %w[ACTIVE FORMER] }
  VALID_PHONE_NUMBER_REGEX = /\d[0-9]\)*\z/.freeze
  validates :phone_number, presence: true, allow_nil: true, length: { maximum: 25 },
                           format: { with: VALID_PHONE_NUMBER_REGEX }
  validate :birthday_in_future
  def birthday_in_future
    errors.add(:birthday, 'is in future') if birthday.present? && birthday > Time.zone.now
  end

  def user_email
    user.email
  end

  def user_id
    user.id
  end

  def self.search(params)
    employees = Employee.includes(:user).all
    employees = employees.where('first_name ILIKE :search OR last_name ILIKE :search OR phone_number ILIKE :search', search: "%#{params[:search]}%") if params[:search].present?
    employees
  end
end
