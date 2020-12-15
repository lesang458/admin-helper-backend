class Api::V1::EmployeesController < ApplicationController
  before_action :find_user, only: %i[update update_status show update_password]
  def index
    set_query_sort if params[:sort].present?
    users = User.search(params).order(@query)
    users = paginate(users)
    month_params = { month: params[:month] ? params[:month].to_datetime : Date.today }.compact
    params[:full_info] == 'true' ? render_collection(users, FullUserSerializer, month_params) : render_collection(users, nil, month_params)
  end

  def show
    render_resource @user, :ok, FullUserSerializer
  end

  def create
    user = User.build_employee(create_params)
    user.save!
    render_resource user, :created, FullUserSerializer
  end

  def update
    User.transaction do
      infos_params = update_params.delete(:day_off_infos_attributes)
      @user.update!(update_params.except(:day_off_infos_attributes))
      @user.update_infos(infos_params) if infos_params.present?
      render_resource @user, :ok, FullUserSerializer
    end
  end

  def update_status
    @user.update!(user_status_params)
    render_resource @user, :ok, FullUserSerializer
  end

  def update_password
    @user.update_password(update_password_params)
    render_resource @user, :ok, FullUserSerializer
  end

  private

  def set_query_sort
    @query = SortParams.new(params[:sort], User).sort_query
  end

  def create_params
    params.permit(:email, :password, :first_name, :last_name, :birthdate, :join_date, :phone_number, :salary_per_month, day_off_infos_attributes:
    %i[day_off_category_id hours])
  end

  def update_params
    params.permit(:email, :first_name, :last_name, :birthdate, :join_date, :phone_number, :salary_per_month, day_off_infos_attributes:
      %i[day_off_category_id status hours])
  end

  def user_status_params
    params.permit(:status)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def update_password_params
    params.permit(:old_password, :new_password)
  end
end
