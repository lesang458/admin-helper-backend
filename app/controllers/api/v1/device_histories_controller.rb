class Api::V1::DeviceHistoriesController < ApplicationController
  def index
    set_paginate
    device_histories = DeviceHistory.search(params)
    device_histories = @page.to_i <= 0 ? device_histories : device_histories.page(@page).per(@per_page)
    render_collection(device_histories, DeviceHistorySerializer)
  end

  def show
    device_history = DeviceHistory.find(params[:id])
    render_resource(device_history, :ok, DeviceHistorySerializer)
  end

  private
end
