class ApplicationController < ActionController::API
  include ExceptionHandler
  include JwtToken

  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def record_not_found(exception)
    render json: {
      message: exception.full_message
    }, status: :not_found
  end
end
