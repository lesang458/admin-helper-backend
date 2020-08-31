class Api::V1::DayOffCategoriesController < ApplicationController
  skip_before_action :set_paginate
  def index
    day_off_categories = DayOffCategory.all
    render_resources(day_off_categories, :ok, DayOffCategorySerializer)
  end
end
