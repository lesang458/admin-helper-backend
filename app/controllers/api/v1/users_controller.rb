class Api::V1::UsersController < ApplicationController
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
    render_resource user, :ok
  end

  def create
    user = User.build_employee(user_params, params[:role])
    user.save!
    render_resource user, :created
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
end
