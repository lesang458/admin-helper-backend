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

  def self.general_search(name, params, employees)
    @time_now = Date.parse(Time.now.to_s)
    query = "#{name} >= ? and #{name} <= ?"
    query_to = "#{name} <= ?"
    name_from = "#{name}"'_from'
    name_to = "#{name}"'_to'
    return employees if params[:"#{name_from}"].nil? && params[:"#{name_to}"].nil?
    from = params[:"#{name_from}"] || @time_now
    to = params[:"#{name_to}"] || @time_now
    return employees.where(query_to, to) unless params[:"#{name_from}"]
    employees.where(query, from, to)
  end

  def self.search(params)
    employees = Employee.includes(:user)
    employees = employees.where('status = :search', search: params[:status]) if params[:status]
    employees = Employee.general_search('birthday', params, employees)
    employees = Employee.general_search('joined_company_date', params, employees)
    employees
  end
end
