class Api::V1::PasswordController < ApplicationController
  skip_before_action :authorize_request, only: %i[create validate_token update]
  before_action :set_user
  before_action :check_token, only: %i[update validate_token]
  def create
    @user.generate_password_token
    @user.send_password_reset_email
    render json: 'ok', status: :ok
  end

  def validate_token
    render json: { valid: true }, status: :ok
  end

  def update
    @user.update!(password_params)
    render json: { message: 'Update success' }, status: :ok
  end

  private

  def password_params
    raise(ExceptionHandler::BadRequest, 'Password must be presence') if params[:new_password].empty?
    params[:encrypted_password] = User.generate_encrypted_password(params[:new_password])
    params.permit(:encrypted_password)
  end

  def set_user
    @user = User.find_by!(email: params[:email])
  end

  def check_token
    raise ExceptionHandler::TokenExpired unless @user.password_token_valid?(params[:token])
  end
end
