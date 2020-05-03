class ApplicationController < ActionController::API
  include JsonResponseHandler
  include ExceptionHandler
end
