class Api::V1::DevicesController < ApplicationController
  before_action :set_current_user

  def create
    device = Device.create_device(device_params, params[:from_date], params[:status])
    render_resource device, :created, DeviceSerializer
  end

  private

  def device_params
    params.permit(:name, :price, :description, :device_category_id, :user_id)
  end
end
