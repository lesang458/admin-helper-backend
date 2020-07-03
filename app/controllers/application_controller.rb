class ApplicationController < ActionController::API
  before_action :authorize_request
  include JsonResponseHandler
  include ExceptionHandler
  include JwtToken
  include Authenticatable
end
