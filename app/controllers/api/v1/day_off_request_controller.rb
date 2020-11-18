class Api::V1::DayOffRequestController < ApplicationController
  before_action :set_day_off_request, only: %i[update destroy cancel]
  def index
    day_off_requests = DayOffRequest.search(params)
    day_off_requests = paginate(day_off_requests)
    render_collection(day_off_requests)
  end

  def create
    info_id = DayOffInfo.id_by_user_and_category(params[:id], params[:day_off_category_id])
    day_off_requests = DayOffRequest.create_requests(day_off_request_params.merge({ day_off_info_id: info_id }), params[:id])
    render_resources(day_off_requests, :created, DayOffRequestSerializer)
  end

  def update
    info_id = DayOffInfo.id_by_user_and_category(@day_off_request.user_id, params[:day_off_category_id])
    @day_off_request.update!(day_off_request_params.merge({ day_off_info_id: info_id }))
    render_resource(@day_off_request)
  end

  def destroy
    @day_off_request.destroy
    head 204
  end

  def cancel
    DayOffRequest.transaction do
      raise(ExceptionHandler::BadRequest, 'Something went wrong when trying to update status day_off_request') unless @day_off_request.pending?
      @day_off_request.cancelled!
      UserMailer.cancel_request(@day_off_request.id).deliver_now # if @day_off_request.cancelled?
      render_resource(@day_off_request)
    end
  end

  private

  def set_day_off_request
    @day_off_request = DayOffRequest.find(params[:id])
  end

  def day_off_request_params
    params.permit(:from_date, :to_date, :hours_per_day, :notes)
  end
end
