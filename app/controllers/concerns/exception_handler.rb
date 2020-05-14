module ExceptionHandler
  include JsonResponseHandler
  extend ActiveSupport::Concern
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render_error(e.message, :not_found)
    end

    rescue_from ExceptionHandler::DecodeError do |_e|
      render_error('You seem to have an invalid token', :unauthorized)
    end

    rescue_from ExceptionHandler::ExpiredSignature do |_e|
      render_error('You seem to have an expired token', :unauthorized)
    end
  end
end
