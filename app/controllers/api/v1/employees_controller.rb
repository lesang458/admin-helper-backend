class Api::V1::EmployeesController < ApplicationController
  before_action :set_current_user
  def index
    employees = Employee.search(params)
    set_paginate
    employees = @page.to_i <= 0 ? employees : employees.page(@page).per(@per_page)
    render_collection(employees, EmployeeSerializer)
  end

  private

  def set_paginate
    @per_page = params[:per_page] || 20
    @page     = params[:page] || 1
  end
end
