class Api::V1::Employees::DayOffInfoController < ApplicationController
  def index
    employee = User.find(params[:id]) if params[:id]
    day_off_infos = employee.day_off_infos if employee
    day_off_infos = paginate(day_off_infos)
    render_collection(day_off_infos)
  end
end
