class Api::V1::Employees::DevicesController < ApplicationController
  def index
    employee = User.find(params[:id])
    devices = employee.devices
    devices = paginate(devices)
    render_collection(devices)
  end
end
