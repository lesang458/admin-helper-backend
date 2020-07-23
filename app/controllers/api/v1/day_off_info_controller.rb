class Api::V1::DayOffInfoController < ApplicationController
  def update
    day_off_info = DayOffInfo.find(params[:id])
    day_off_info.update!(info_params)
    render json: { "day-off-info": day_off_info }, status: :ok
  end

  private

  def info_params
    params.permit(:day_off_category_id, :hours)
  end
end
