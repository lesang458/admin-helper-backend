class Api::V1::DayOffCategoriesController < ApplicationController
  skip_before_action :set_paginate
  def index
    day_off_categories = DayOffCategory.all
    render_resources(day_off_categories, :ok, DayOffCategorySerializer)
  end

  def update
    day_off_category = DayOffCategory.find params[:id]
    day_off_category.update!(day_off_category_params)
    render_resource(day_off_category, :ok, DayOffCategorySerializer)
  end

  def create
    day_off_category = DayOffCategory.new(day_off_category_params)
    day_off_category.save!
    render_resource day_off_category, :created, DayOffCategorySerializer
  end

  private

  def day_off_category_params
    params.permit(:name, :total_hours_default, :description)
  end
end
