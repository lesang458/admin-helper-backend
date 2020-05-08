class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by!(email: params[:email])
    if user&.check_valid_password(params[:password])
      jwt = JwtToken.render_user_authorized_token user.render_payload
      render json: { jwt: jwt }
    else
      render_bad_request_error 'Invalid email or password'
    end
  end
end
