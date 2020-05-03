class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user.check_valid_password(params[:password], user.encrypted_password)
      jwt = JwtToken.encode({ 'user_id' => user.id }, 24.hours.from_now, ENV['AUTH_SECRET'])
      render json: { jwt: jwt }
    else
      render json: { errors: 'Invalid email or password' }, status: 422
    end
  end
end
