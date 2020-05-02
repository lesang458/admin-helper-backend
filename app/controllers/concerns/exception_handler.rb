module ExceptionHandler
  include JsonResponseHandler
  extend ActiveSupport::Concern
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  included do
    rescue_from ExceptionHandler::DecodeError do |_error|
      JsonResponseHandler.render_unauthorized_error _error
    end

    rescue_from ExceptionHandler::ExpiredSignature do |_error|
      JsonResponseHandler.render_unauthorized_error _error
    end
  end
end
