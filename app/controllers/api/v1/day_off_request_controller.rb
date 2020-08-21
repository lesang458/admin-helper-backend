class Api::V1::DayOffRequestController < ApplicationController
  def index
    set_paginate
    day_off_requests = DayOffRequest.search(params)
    day_off_requests = @page.to_i <= 0 ? day_off_requests : day_off_requests.page(@page).per(@per_page)
    render_collection(day_off_requests, DayOffRequestSerializer)
  end

  def create
    day_off_requests = DayOffRequest.create_requests(day_off_request_params, params[:id])
    render_resources(day_off_requests, :created, DayOffRequestSerializer)
  end

  private

  def day_off_request_params
    params.permit(:from_date, :to_date, :hours_per_day, :notes, :day_off_info_id)
  end

  def set_paginate
    @per_page = params[:per_page] || 20
    @page = params[:page] || 1
  end
end
