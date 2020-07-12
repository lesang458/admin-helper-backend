class Api::V1::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: [:create]
  def create
    user = User.find_by(email: params[:email])
    if user&.check_valid_password(params[:password])
      jwt = JwtToken.render_user_authorized_token user.jwt_payload
      render json: { token: "Bearer #{jwt}", user: UserSerializer.new(user), day_off_info: user.day_off_infos.collect { |day_off| DayOffInfoSerializer.new(day_off) } }
    else
      render_bad_request_error 'Invalid email or password'
    end
  end
end
