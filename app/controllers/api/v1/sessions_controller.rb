class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.check_valid_password(params[:password])
      jwt = JwtToken.render_user_authorized_token user.jwt_payload
      render json: { token: "Bearer #{jwt}", user: UserSerializer.new(user) }
    else
      render_bad_request_error 'Invalid email or password'
    end
  end
end
