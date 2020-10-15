class Api::V1::DevicesController < ApplicationController
  before_action :set_current_user
  before_action :set_device, only: %i[assign discard destroy update show]
  def update
    @device.update!(device_params)
    render_resource @device, :ok, DeviceSerializer
  end

  def create
    device = Device.create_device(device_params, history_params)
    render_resource device, :created, DeviceSerializer
  end

  def show
    render_resource(@device, :ok, DeviceSerializer)
  end

  def index
    devices = Device.search(params)
    devices = paginate(devices)
    render_collection(devices, DeviceSerializer)
  end

  def assign
    @device.assign(params[:user_id])
    render_resource @device, :ok, DeviceSerializer
  end

  def discard
    @device.discard
    render_resource @device, :ok, DeviceSerializer
  end

  def move_to_inventory
    device = Device.find params[:id]
    device.move_to_inventory
    render_resource device, :ok, DeviceSerializer
  end

  def destroy
    @device.destroy
    head :no_content
  end

  private

  def device_params
    params.permit(:name, :price, :description, :device_category_id, :user_id)
  end

  def history_params
    params.permit(:from_date, :status)
  end

  def set_device
    @device = Device.find(params[:id])
  end
end
