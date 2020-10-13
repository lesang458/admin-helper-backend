class Api::V1::DayOffCategoriesController < ApplicationController
  before_action :find_day_off_category, only: %i[update deactivate activate]
  def index
    day_off_categories = DayOffCategory.search(params)
    day_off_categories = paginate(day_off_categories)
    render_collection(day_off_categories, DayOffCategorySerializer)
  end

  def update
    @day_off_category.update!(day_off_category_params)
    render_resource(@day_off_category, :ok, DayOffCategorySerializer)
  end

  def deactivate
    raise(ExceptionHandler::BadRequest, 'Day off category was deactivated') if @day_off_category.inactive?
    @day_off_category.inactive!
    render_resource(@day_off_category, :ok, DayOffCategorySerializer)
  end

  def activate
    raise(ExceptionHandler::BadRequest, 'Day off category was activated') if @day_off_category.active?
    @day_off_category.active!
    render_resource(@day_off_category, :ok, DayOffCategorySerializer)
  end

  def create
    day_off_category = DayOffCategory.new(day_off_category_params)
    day_off_category.save!
    render_resource day_off_category, :created, DayOffCategorySerializer
  end

  private

  def find_day_off_category
    @day_off_category = DayOffCategory.find params[:id]
  end

  def day_off_category_params
    params.permit(:name, :total_hours_default, :description)
  end
end
