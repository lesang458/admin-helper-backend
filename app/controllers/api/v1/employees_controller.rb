class Api::V1::EmployeesController < ApplicationController
  before_action :set_current_user
  before_action :find_user, only: %i[update update_status show]
  def index
    set_query_sort if params[:sort].present?
    users = User.search(params).order(@query)
    users = @page.to_i <= 0 ? users : users.page(@page).per(@per_page)
    render_collection(users, UserSerializer)
  end

  def show
    render_resource @user, :ok, UserSerializer
  end

  def create
    user = User.build_employee(create_params)
    user.save!
    render_resource user, :created, UserSerializer
  end

  def update
    @user.handle_many_overlapping_category(params[:user][:day_off_infos_attributes])
    @user.update!(update_params)
    render_resource @user, :ok, UserSerializer
  end

  def update_status
    @user.update!(user_status_params)
    render_resource @user, :ok, UserSerializer
  end

  private

  def set_query_sort
    @query = SortParams.new(params[:sort], User).sort_query
  end

  def create_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :birthdate, :join_date, :phone_number, day_off_infos_attributes:
    %i[day_off_category_id hours])
  end

  def update_params
    params.require(:user).permit(:email, :first_name, :last_name, :birthdate, :join_date, :phone_number, day_off_infos_attributes:
      %i[id day_off_category_id hours])
  end

  def user_status_params
    params.permit(:status)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
