class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by!(email: params[:email])
    if user&.check_valid_password(params[:password])
      jwt = JwtToken.render_user_authorized_token(user.render_payload, JwtToken.render_secret_key_base)
      render json: { jwt: jwt }
    else
      render json: { errors: 'Invalid email or password' }, status: :unprocessable_entity
    end
  end
end
