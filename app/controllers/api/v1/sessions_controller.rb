class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by!(email: params[:email])
    unless user&.check_valid_password(params[:password])
      raise(
        ExceptionHandler::WrongPassword
      )
    end
    jwt = JwtToken.render_user_authorized_token user.render_payload
    render json: { jwt: jwt }
  end
end
