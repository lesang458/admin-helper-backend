class Api::V1::DayOffRequestController < ApplicationController
  def index
    day_off_requests = DayOffRequest.search(params)
    day_off_requests = @page.to_i <= 0 ? day_off_requests : day_off_requests.page(@page).per(@per_page)
    render_collection(day_off_requests, DayOffRequestSerializer)
  end

  def create
    info_id = DayOffInfo.id_by_user_and_category(params[:id], params[:day_off_category_id])
    day_off_requests = DayOffRequest.create_requests(day_off_request_params.merge({ day_off_info_id: info_id }), params[:id])
    render_resources(day_off_requests, :created, DayOffRequestSerializer)
  end

  def update
    day_off_request = DayOffRequest.find(params[:id])
    info_id = DayOffInfo.id_by_user_and_category(day_off_request.user_id, params[:day_off_category_id])
    day_off_request.update!(day_off_request_params.merge({ day_off_info_id: info_id }))
    render_resource(day_off_request, :ok, DayOffRequestSerializer)
  end

  private

  def day_off_request_params
    params.permit(:from_date, :to_date, :hours_per_day, :notes)
  end
end
