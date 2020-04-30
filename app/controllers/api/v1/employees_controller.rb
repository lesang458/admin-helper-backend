class Api::V1::EmployeesController < ApplicationController
  def index
    employee = User.all.map(&:employee)
    render_resource employee
  end
end
