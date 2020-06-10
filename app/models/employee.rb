class Employee < ApplicationRecord
  belongs_to :user
  validates :first_name, presence: true, length: { in: 2..20 }
  validates :last_name, presence: true, length: { in: 2..20 }
  enum status: { ACTIVE: 'ACTIVE', FORMER: 'FORMER' }
  validates :status, presence: true, inclusion: { in: %w[ACTIVE FORMER] }
  VALID_PHONE_NUMBER_REGEX = /\d[0-9]\)*\z/.freeze
  validates :phone_number, presence: true, length: { maximum: 25 },
                           format: { with: VALID_PHONE_NUMBER_REGEX }
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

  def self.search_by_date_range(name, date_from, date_to, employees)
    return employees if date_from.nil? && date_to.nil?
    query_between_date = "#{name} >= ? and #{name} <= ?"
    query_to = "#{name} <= ?"
    from = date_from || Date.today
    to = date_to || Date.today
    return employees.where(query_to, to) unless date_from
    employees.where(query_between_date, from, to)
  end
end
