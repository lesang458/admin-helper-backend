class Api::V1::EmployeesController < ApplicationController
  def render_collection
    employees = @page.to_i <= 0 ? Employee.all : Employee.page(@page).per(@per_page)
    render_collection_employees employees
  end

  before_action :set_peginate

  private

  def set_peginate
    @per_page = params[:per_page].nil? ? 20 : params[:per_page]
    @page     = params[:page].nil? ? 1 : params[:page]
  end
end
