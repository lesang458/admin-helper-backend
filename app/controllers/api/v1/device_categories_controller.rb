class Api::V1::DeviceCategoriesController < ApplicationController
  def index
    set_paginate
    device_categories = DeviceCategory.all_categories
    device_categories = @page.to_i <= 0 ? device_categories : device_categories.page(@page).per(@per_page)
    render_collection(device_categories, DeviceCategorySerializer)
  end

  private

  def set_paginate
    @per_page = params[:per_page] || 20
    @page = params[:page] || 1
  end
end
