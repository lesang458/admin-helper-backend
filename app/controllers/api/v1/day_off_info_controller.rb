class Api::V1::DayOffInfoController < ApplicationController
  before_action :find_day_off_info, only: %i[update deactivate]
  def index
    day_off_infos = DayOffInfo.search(params)
    day_off_infos = paginate(day_off_infos)
    render_collection(day_off_infos, DayOffInfoSerializer)
  end

  def update
    @day_off_info.update!(info_params)
    render_resource(@day_off_info, :ok, DayOffInfoSerializer)
  end

  def deactivate
    raise(ExceptionHandler::BadRequest, 'Day off info was deactivated') if @day_off_info.inactive?
    @day_off_info.inactive!
    render_resource(@day_off_info, :ok, DayOffInfoSerializer)
  end

  private

  def find_day_off_info
    @day_off_info = DayOffInfo.find params[:id]
  end

  def info_params
    params.permit(:day_off_category_id, :hours)
  end
end
