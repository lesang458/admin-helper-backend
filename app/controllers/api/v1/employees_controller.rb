class Api::V1::EmployeesController < ApplicationController
  before_action :set_current_user
  def index
    set_paginate
    set_query_sort if params[:sort].present?
    employees = Employee.sort_by(@query).search(params)
    employees = @page.to_i <= 0 ? employees : employees.page(@page).per(@per_page)
    render_collection(employees, EmployeeSerializer)
  end

  def show
    employee = Employee.find(params[:id])
    render_resource employee
  end

  private

  def set_paginate
    @per_page = params[:per_page] || 20
    @page = params[:page] || 1
  end

  def set_query_sort
    @query = params[:sort].tr(':', ' ')
    @query.split(',') do |query|
      raise ExceptionHandler::BadRequest unless Employee.check_params_sort_type query.split(' ')[0].downcase, query.split(' ')[1].downcase
    end
  end
end
