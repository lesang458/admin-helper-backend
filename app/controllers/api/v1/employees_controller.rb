class Api::V1::EmployeesController < ApplicationController
  before_action :set_current_user
  def index
    set_paginate
    set_query_sort if params[:sort].present?
    users = User.search(params).order(@query)
    users = @page.to_i <= 0 ? users : users.page(@page).per(@per_page)
    render_collection(users, UserSerializer)
  end

  def show
    user = User.find(params[:id])
    render_resource 'employee', user, :ok, UserSerializer
  end

  def create
    User.transaction do
      user = User.build_employee(user_params)
      user.save!
      DayOffInfo.create_day_off_info(day_off_params[:day_off_info], user)
      render_resource 'employee', user, :created, UserSerializer
    end
  end

  def update
    user = User.find(params[:id])
    user.update!(user_params)
    render_resource 'employee', user, :ok, UserSerializer
  end

  def update_status
    user = User.find(params[:id])
    user.update!(user_status_params)
    render_resource 'employee', user, :ok, UserSerializer
  end

  private

  def set_paginate
    @per_page = params[:per_page] || 20
    @page = params[:page] || 1
  end

  def set_query_sort
    @query = SortParams.new(params[:sort], User).sort_query
  end

  def user_params
    params[:encrypted_password] = User.generate_encrypted_password(params[:encrypted_password])
    params.permit(:email, :encrypted_password, :first_name, :last_name, :birthdate, :join_date, :phone_number)
  end

  def day_off_params
    params.permit(day_off_info: %i[day_off_category_id hours])
  end

  def user_status_params
    params.permit(:status)
  end
end
