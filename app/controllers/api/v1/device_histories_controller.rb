class Api::V1::DeviceHistoriesController < ApplicationController
  def index
    device_histories = DeviceHistory.search(params)
    device_histories = paginate(device_histories)
    render_collection(device_histories)
  end

  def show
    device_history = DeviceHistory.find(params[:id])
    render_resource(device_history, :ok)
  end
end
