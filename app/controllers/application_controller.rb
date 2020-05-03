class ApplicationController < ActionController::API
  include ExceptionHandler
  include JwtToken
end
