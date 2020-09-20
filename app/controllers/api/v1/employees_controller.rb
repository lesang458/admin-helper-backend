class Api::V1::EmployeesController < ApplicationController
  before_action :set_current_user
  def index
    set_query_sort if params[:sort].present?
    users = User.search(params).order(@query)
    users = @page.to_i <= 0 ? users : users.page(@page).per(@per_page)
    render_collection(users, UserSerializer)
  end

  def show
    user = User.find(params[:id])
    render_resource user, :ok, UserSerializer
  end

  def create
    User.transaction do
      user = User.build_employee(create_params)
      user.save!
      DayOffInfo.create_day_off_info(day_off_params[:day_off_infos], user)
      render_resource user, :created, UserSerializer
    end
  end

  def update
    User.transaction do
      user = User.find(params[:id])
      user.update!(update_params)
      DayOffInfo.update_day_off_info(params_update_day_off[:day_off_infos], user)
      render_resource user, :ok, UserSerializer
    end
  end

  def update_status
    user = User.find(params[:id])
    user.update!(user_status_params)
    render_resource user, :ok, UserSerializer
  end

  private

  def set_query_sort
    @query = SortParams.new(params[:sort], User).sort_query
  end

  def create_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :birthdate, :join_date, :phone_number)
  end

  def update_params
    params.require(:user).permit(:email, :first_name, :last_name, :birthdate, :join_date, :phone_number)
  end

  def day_off_params
    params.permit(day_off_infos: %i[day_off_category_id hours])
  end

  def params_update_day_off
    params.permit(day_off_infos: %i[day_off_info_id day_off_category_id hours])
  end

  def user_status_params
    params.permit(:status)
  end
end
