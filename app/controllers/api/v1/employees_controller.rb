class Api::V1::EmployeesController < ApplicationController
  before_action :set_current_user
  def index
    set_paginate
    set_query_sort if params[:sort].present?
    employees = Employee.search(params).order(@query)
    employees = @page.to_i <= 0 ? employees : employees.page(@page).per(@per_page)
    render_collection(employees, EmployeeSerializer)
  end

  def show
    employee = Employee.find(params[:id])
    render_resource employee, :ok
  end

  def create
    user = User.new email: params[:email], encrypted_password: User.generate_encrypted_password(User::DEFAULTPASSWORD)
    employee = Employee.new(employee_params)
    employee.user = user if user.save!
    employee.save!
    render_resource employee, :created
  end

  private

  def set_paginate
    @per_page = params[:per_page] || 20
    @page = params[:page] || 1
  end

  def set_query_sort
    @query = SortParams.new(params[:sort], Employee).sort_query
  end

  def employee_params
    params.permit(:first_name, :last_name, :birthday, :joined_company_date, :phone_number)
  end
end
