class Employee < ApplicationRecord
  belongs_to :user
  validates :first_name, presence: true, length: { in: 2..20 }
  validates :last_name, presence: true, length: { in: 2..20 }
  enum status: { ACTIVE: 'ACTIVE', FORMER: 'FORMER' }
  validates :status, presence: true, inclusion: { in: %w[ACTIVE FORMER] }
  VALID_PHONE_NUMBER_REGEX = /\d[0-9]\)*\z/.freeze
  validates :phone_number, presence: true, length: { maximum: 25 },
                           format: { with: VALID_PHONE_NUMBER_REGEX }
  scope :birthday_to, ->(to) { where('birthday <= ?', to) if to }
  scope :birthday_from, ->(from) { where('birthday >= ?', from) if from }
  scope :join_date_to, ->(to) { where('joined_company_date <= ?', to) if to }
  scope :join_date_from, ->(from) { where('joined_company_date >= ?', from) if from }
  def user_email
    user.email
  end

  def user_id
    user.id
  end

  # rubocop:disable Metrics/AbcSize
  def self.search(params)
    employees = Employee.includes(:user)
    employees = employees.where('first_name ILIKE :search OR last_name ILIKE :search OR phone_number ILIKE :search', search: "%#{params[:search]}%") if params[:search].present?
    employees = employees.where('status = :search', search: params[:status]) if params[:status]
    employees = employees.birthday_to(params[:birthday_to])
    employees = employees.birthday_from(params[:birthday_from])
    employees = employees.join_date_to(params[:joined_company_date_to])
    employees = employees.join_date_from(params[:joined_company_date_from])
    employees
  end
  # rubocop:enable Metrics/AbcSize
end
