class Api::V1::DeviceCategoriesController < ApplicationController
  def index
    set_paginate
    device_categories = DeviceCategory.all_categories
    device_categories = @page.to_i <= 0 ? device_categories : device_categories.page(@page).per(@per_page)
    render_collection(device_categories, DeviceCategorySerializer)
  end

  def show
    device_category = DeviceCategory.find(params[:id])
    render_resource(device_category, :ok, DeviceCategorySerializer)
  end

  def create
    device_category = DeviceCategory.create! device_category_params
    render_resource(device_category, :created, DeviceCategorySerializer)
  end

  def destroy
    DeviceCategory.destroy(params[:id])
    head :no_content
  end

  def update
    category = DeviceCategory.find(params[:id])
    category.update!(device_category_params)
    render_resource category, :ok, DeviceCategorySerializer
  end

  private

  def set_paginate
    @per_page = params[:per_page] || 20
    @page = params[:page] || 1
  end

  def device_category_params
    params.permit(:name, :description)
  end
end
