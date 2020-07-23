class Api::V1::DayOffInfoController < ApplicationController
  def update
    user = User.find(params[:id])
    user.day_off_info.update!(user_params)
    render json: { "day-off-info": user.day_off_info }, status: :ok
  end

  private

  def info_params
    params.permit(:day_off_category_id, :hours)
  end
end
