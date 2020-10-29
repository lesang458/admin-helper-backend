module Authenticatable
  def set_current_user
    @current_user = AuthorizeApiRequest.new(request.headers['Authorization']).current_user
  end

  def user_login
    return User.find_by(email: params[:email]) || User.find_by(email: GoogleApis::IdTokens.get_user_info(params[:id_token])['email']) if params['controller'].split('/')[2].eql? 'sessions'

    set_current_user
  end

  def authorize_request
    raise(ExceptionHandler::BadRequest, 'Invalid User') unless user_login
    PermissionRequest.new(user_login, params['controller'].split('/')[2], params['action'])
  end
end
