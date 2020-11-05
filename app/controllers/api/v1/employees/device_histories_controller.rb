class Api::V1::Employees::DeviceHistoriesController < ApplicationController
  def index
    employee = User.find(params[:id])
    device_histories = employee.device_histories
    device_histories = paginate(device_histories)
    render_collection(device_histories)
  end
end
