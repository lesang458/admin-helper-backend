module ExceptionHandler
  include JsonResponseHandler
  extend ActiveSupport::Concern
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  included do
    rescue_from ExceptionHandler::DecodeError do |e|
      JsonResponseHandler.render_unauthorized_error e
    end

    rescue_from ExceptionHandler::ExpiredSignature do |e|
      JsonResponseHandler.render_unauthorized_error e
    end
  end
end
