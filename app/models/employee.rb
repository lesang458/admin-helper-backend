class Employee < ApplicationRecord
  belongs_to :user
  validates :first_name, presence: true, length: { in: 2..20 }
  validates :last_name, presence: true, length: { in: 2..20 }
  enum status: { ACTIVE: 'ACTIVE', FORMER: 'FORMER' }
  validates :status, presence: true, inclusion: { in: %w[ACTIVE FORMER] }
  VALID_PHONE_NUMBER_REGEX = /\d[0-9]\)*\z/.freeze
  validates :phone_number, presence: true, length: { maximum: 255 },
                           format: { with: VALID_PHONE_NUMBER_REGEX }
  def user_email
    user.email
  end

  def user_id
    user.id
  end

  def self.search(params)
    employees = Employee.includes(:user).all
    employees = employees.where('first_name ILIKE :search OR last_name ILIKE :search OR phone_number ILIKE :search', search: "%#{params[:search]}%") if params[:search].present?
    raise ExceptionHandler::NoContent if employees.blank?
    employees
  end
end
