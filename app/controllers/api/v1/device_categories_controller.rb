class Api::V1::DeviceCategoriesController < ApplicationController
  def index
    device_categories = DeviceCategory.by_all_device_categories
    render json: device_categories, status: :ok
  end
end
