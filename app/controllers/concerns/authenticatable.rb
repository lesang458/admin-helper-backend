module Authenticatable
  def set_current_user
    @current_user = AuthorizeApiRequest.new(request.headers['Authorization']).current_user
  end
end
