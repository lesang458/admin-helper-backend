class Api::V1::DayOffInfoController < ApplicationController
  def index
    set_paginate
    day_off_infos = DayOffInfo.search(params)
    day_off_infos = @page.to_i <= 0 ? day_off_infos : day_off_infos.page(@page).per(@per_page)
    render_collection(day_off_infos, DayOffInfoSerializer)
  end

  def update
    day_off_info = DayOffInfo.find(params[:id])
    day_off_info.update!(info_params)
    render_resource(day_off_info, :ok, DayOffInfoSerializer)
  end

  private

  def set_paginate
    @per_page = params[:per_page] || 20
    @page = params[:page] || 1
  end

  def info_params
    params.permit(:day_off_category_id, :hours)
  end
end
