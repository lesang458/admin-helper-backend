class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include JsonResponseHandler
  include ExceptionHandler
  include JwtToken
  include Authenticatable
  before_action :authorize_request
end
