class Api::V1::DayOffRequestController < ApplicationController
  def index
    day_off_requests = DayOffRequest.search(params)
    render_list_request(day_off_requests, DayOffRequestSerializer)
  end

  def create
    employee = User.find(params[:id])
    day_off_request = employee.day_off_requests.build(day_off_request_params)
    day_off_request.save!
    render_resource(day_off_request, :created, DayOffRequestSerializer)
  end

  private

  def day_off_request_params
    params.permit(:from_date, :to_date, :hours_per_day, :notes, :day_off_info_id)
  end
end
