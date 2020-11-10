module Authenticatable
  def current_user
    @current_user ||= AuthorizeApiRequest.new(request.headers['Authorization']).current_user
  end

  def logged_in_user
    return User.find_by(email: params[:email]) || User.find_by(email: GoogleApis::IdTokens.get_user_info(params[:id_token])['email']) if controller_name.eql? 'sessions'

    current_user
  end

  def authorize_request
    raise(ExceptionHandler::BadRequest, 'Invalid User') unless logged_in_user
    PermissionRequest.new(logged_in_user, controller_name, params['action'])
  end
end
