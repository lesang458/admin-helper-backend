class Employee < ApplicationRecord
  belongs_to :user
  validates :first_name, presence: true, length: { in: 2..20 }
  validates :last_name, presence: true, length: { in: 2..20 }
  enum status: { ACTIVE: 'ACTIVE', FORMER: 'FORMER' }
  validates :status, presence: true, inclusion: { in: %w[ACTIVE FORMER] }

  def user_email
    user.email
  end

  def user_id
    user.id
  end

  def self.search(params)
    employees = Employee.includes(:user)
    employees = employees.where('status = :search', search: params[:status]) if params[:status]
    employees = Employee.search_by_date_range('birthday', params[:birthday_from], params[:birthday_to], employees)
    employees = Employee.search_by_date_range('joined_company_date', params[:joined_company_date_from], params[:joined_company_date_to], employees)
    employees
  end

  def self.search_by_date_range(name, date_from, date_to, employees)
    @time_now = Date.parse(Time.now.to_s)
    query = "#{name} >= ? and #{name} <= ?"
    query_to = "#{name} <= ?"
    return employees if date_from.nil? && date_to.nil?
    from = date_from || @time_now
    to = date_to || @time_now
    return employees.where(query_to, to) unless date_from
    employees.where(query, from, to)
  end
end
