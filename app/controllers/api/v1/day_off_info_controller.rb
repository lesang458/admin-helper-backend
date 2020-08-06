class Api::V1::DayOffInfoController < ApplicationController
  def update
    day_off_info = DayOffInfo.find(params[:id])
    day_off_info.update!(info_params)
    render_resource('day-off-info', day_off_info, :ok, DayOffInfoSerializer)
  end

  private

  def info_params
    params.permit(:day_off_category_id, :hours)
  end
end
