class Api::V1::DeviceCategoriesController < ApplicationController
  def index
    device_categories = DeviceCategory.all_categories
    device_categories = paginate(device_categories)
    render_collection(device_categories, DeviceCategorySerializer)
  end

  def show
    device_category = DeviceCategory.find(params[:id])
    render_resource(device_category, :ok, DeviceCategorySerializer)
  end

  def create
    device_category = DeviceCategory.create! category_params
    render_resource(device_category, :created, DeviceCategorySerializer)
  end

  def update
    category = DeviceCategory.find(params[:id])
    category.update!(category_params)
    render_resource category, :ok, DeviceCategorySerializer
  end

  private

  def category_params
    params.permit(:name, :description)
  end
end
