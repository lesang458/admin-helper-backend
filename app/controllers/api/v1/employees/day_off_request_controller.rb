class Api::V1::Employees::DayOffRequestController < ApplicationController
  def index
    employee = User.find(params[:id])
    day_off_requests = employee.day_off_requests
    day_off_requests = paginate(day_off_requests)
    render_collection(day_off_requests)
  end
end
