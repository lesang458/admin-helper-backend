class Api::V1::EmployeesController < ApplicationController
  def index
    employees = @page.to_i <= 0 ? Employee.all : Employee.page(@page).per(@per_page)
    render_collection employees
  end

  before_action :set_paginate

  private

  def set_paginate
    @per_page = params[:per_page].nil? ? 20 : params[:per_page]
    @page     = params[:page].nil? ? 1 : params[:page]
  end
end
