class Employee < ApplicationRecord
  belongs_to :user
  validates :first_name, presence: true, length: { in: 2..20 }
  validates :last_name, presence: true, length: { in: 2..20 }
  enum status: { ACTIVE: 'ACTIVE', FORMER: 'FORMER' }
  validates :status, presence: true, inclusion: { in: %w[ACTIVE FORMER] }
  VALID_PHONE_NUMBER_REGEX = /\d[0-9]\)*\z/.freeze
  validates :phone_number, presence: true, length: { maximum: 25 },
                           format: { with: VALID_PHONE_NUMBER_REGEX }
  scope :query_by_date, ->(field, value, operator) { where "#{field} #{operator} ?", value }
  def user_email
    user.email
  end

  def user_id
    user.id
  end

  def self.search(params)
    employees = Employee.includes(:user)
    employees = employees.where('first_name ILIKE :search OR last_name ILIKE :search OR phone_number ILIKE :search', search: "%#{params[:search]}%") if params[:search].present?
    employees = employees.where('status = :search', search: params[:status]) if params[:status]
    employees = Employee.search_by_date_range('birthday', params[:birthday_from], params[:birthday_to], employees)
    employees = Employee.search_by_date_range('joined_company_date', params[:joined_company_date_from], params[:joined_company_date_to], employees)
    employees
  end

  def self.search_by_date_range(name, from_date, to_date, employees)
    return employees if from_date.nil? && to_date.nil?
    to_date ||= Date.today
    employees = employees.query_by_date(name, to_date, '<=')
    employees = employees.query_by_date(name, from_date, '>=') if from_date.present?
    employees
  end
end
