class Api::V1::DeviceCategoriesController < ApplicationController
  def index
    device_categories = DeviceCategory.all_categories
    render json: device_categories, status: :ok
  end
end
