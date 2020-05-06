class ApplicationController < ActionController::API
  include JsonResponseHandler
  include ExceptionHandler

  def instantiate_class(name_class)
    Object.const_get name_class.to_s
  end
end
