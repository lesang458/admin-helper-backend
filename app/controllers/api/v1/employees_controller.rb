class Api::V1::EmployeesController < ApplicationController
  before_action :set_paginate, :set_current_user
  def index
    employees = @page.to_i <= 0 ? Employee.includes(:user).all : Employee.includes(:user).page(@page).per(@per_page)
    render_collection(employees, EmployeeSerializer)
  end

  private

  def set_paginate
    @per_page = params[:per_page] || 20
    @page     = params[:page] || 1
  end

  def set_current_user
    @current_user = AuthorizeApiRequest.new(request.headers['Authorization']).current_user
  end
end
