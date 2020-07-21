class ApplicationController < ActionController::API
  include JsonResponseHandler
  include ExceptionHandler
  include JwtToken
  include Authenticatable
  include GetGoogleUserinfo
  before_action :authorize_request
end
