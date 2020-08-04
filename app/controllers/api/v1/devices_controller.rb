class Api::V1::DevicesController < ApplicationController
  before_action :set_current_user

  def create
    Device.transaction do
      User.find(params[:user_id]) if params[:user_id]
      device = Device.create!(device_params)
      DeviceHistory.create_device_history(params[:from_date] || Time.zone.now, device)
      render_resource device, :created, DeviceSerializer
    end
  end

  private

  def device_params
    params.permit(:name, :price, :description, :device_category_id, :user_id)
  end
end
