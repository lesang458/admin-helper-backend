class Api::V1::DevicesController < ApplicationController
  before_action :set_current_user

  def create
    device = Device.create_device(device_params, history_params)
    render_resource device, :created, DeviceSerializer
  end

  def show
    device = Device.find(params[:id])
    render_resource(device, :ok, DeviceSerializer)
  end

  def index
    set_paginate
    devices = Device.search(params)
    devices = @page.to_i <= 0 ? devices : devices.page(@page).per(@per_page)
    render_collection(devices, DeviceSerializer)
  end

  private

  def set_paginate
    @per_page = params[:per_page] || 20
    @page = params[:page] || 1
  end

  def device_params
    params.permit(:name, :price, :description, :device_category_id, :user_id)
  end

  def history_params
    params.permit(:from_date, :status)
  end
end