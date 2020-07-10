class Api::V1::PasswordController < ApplicationController
  skip_before_action :authorize_request, only: %i[create valid_token update]
  before_action :set_user
  before_action :check_expired, only: [:update]
  def create
    @user.generate_password_token
    @user.send_password_reset_email
    render json: 'ok', status: :ok
  end

  def valid_token
    if @user.password_token_valid?(params[:token]) && @user.password_reset_not_expired?
      render json: { message: 'isValid: true' }, status: :ok
    else
      render_bad_request_error('isValid: false')
    end
  end

  def update
    @user.update!(password_params)
    render json: { message: 'Update success' }, status: :ok
  end

  private

  def password_params
    raise(ExceptionHandler::BadRequest, 'Password have to presence') if params[:new_password].empty?
    params[:encrypted_password] = User.generate_encrypted_password(params[:new_password])
    params.permit(:encrypted_password)
  end

  def set_user
    @user = User.find_by!(email: params[:email])
  end

  def check_expired
    raise ExceptionHandler::TokenExpired unless @user.password_reset_expired? && @user.password_token_valid?(params[:token])
  end
end
