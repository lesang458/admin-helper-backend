class Api::V1::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: %i[create google_login]
  def create
    user = User.find_by(email: params[:email])
    if user&.check_valid_password(params[:password])
      jwt = JwtToken.render_user_authorized_token user.jwt_payload
      render json: { token: "Bearer #{jwt}", user: UserSerializer.new(user) }
    else
      render_bad_request_error 'Invalid email or password'
    end
  end

  def google_login
    user = User.find_by(email: google_user_email)
    if user
      jwt = JwtToken.render_user_authorized_token user.jwt_payload
      render json: { token: "Bearer #{jwt}", user: UserSerializer.new(user) }
    else
      render_bad_request_error 'Invalid User'
    end
  end

  private

  def google_user_email
    GoogleApis::IdTokens.get_user_info(params[:id_token])['email']
  end
end
