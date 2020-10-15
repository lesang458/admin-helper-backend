class Api::V1::DayOffInfoController < ApplicationController
  def index
    day_off_infos = DayOffInfo.search(params)
    day_off_infos = paginate(day_off_infos)
    render_collection(day_off_infos)
  end

  def update
    day_off_info = DayOffInfo.find(params[:id])
    day_off_info.update!(info_params)
    render_resource(day_off_info, :ok)
  end

  private

  def info_params
    params.permit(:day_off_category_id, :hours)
  end
end
