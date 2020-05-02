module ExceptionHandler
  include RenderMessage
  extend ActiveSupport::Concern
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  included do
    rescue_from ExceptionHandler::DecodeError do |_error|
      RenderMessage.invalid_token
    end

    rescue_from ExceptionHandler::ExpiredSignature do |_error|
      RenderMessage.expired_token
    end
  end
end
