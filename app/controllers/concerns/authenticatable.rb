module Authenticatable
  def set_current_user
    @current_user = AuthorizeApiRequest.new(request.headers['Authorization']).current_user
  end

  def authorize_request
    PermissionRequest.new(set_current_user, params['controller'].split('/')[2], params['action'])
  end
end
