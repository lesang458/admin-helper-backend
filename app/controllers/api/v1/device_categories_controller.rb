class Api::V1::DeviceCategoriesController < ApplicationController
  def index
    device_categories = DeviceCategory.all_categories
    render json: device_categories, status: :ok
  end

  def show
    device_category = DeviceCategory.find(params[:id])
    render json: { device_category: device_category }, status: :ok
  end

  def create
    device_category = DeviceCategory.create! device_category_params
    render json: { device_category: device_category }, status: :created
  end

  private

  def device_category_params
    params.permit(:name, :description)
  end
end
