class Api::V1::DayOffCategoriesController < ApplicationController
  before_action :find_day_off_category, only: %i[update deactivate]
  def index
    day_off_categories = DayOffCategory.search(params[:status])
    day_off_categories = @page.to_i <= 0 ? day_off_categories : day_off_categories.page(@page).per(@per_page)
    render_collection(day_off_categories, DayOffCategorySerializer)
  end

  def update
    @day_off_category.update!(day_off_category_params)
    render_resource(@day_off_category, :ok, DayOffCategorySerializer)
  end

  def deactivate
    @day_off_category.update!(status: params[:status])
    render_resource(@day_off_category, :ok, DayOffCategorySerializer)
  end

  private

  def find_day_off_category
    @day_off_category = DayOffCategory.find params[:id]
  end

  def day_off_category_params
    params.permit(:name, :total_hours_default, :description, :status)
  end
end
