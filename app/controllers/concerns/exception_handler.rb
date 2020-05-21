module ExceptionHandler
  include JsonResponseHandler
  extend ActiveSupport::Concern
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class Unauthorized < StandardError; end
  class NoContent < StandardError; end
  included do
    rescue_from ExceptionHandler::NoContent do
      render_error('No Content', :no_content)
    end

    rescue_from ExceptionHandler::Unauthorized do
      render_error('User authentication failed', :unauthorized)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render_error(e.message, :not_found)
    end

    rescue_from ExceptionHandler::DecodeError do |e|
      render_error(e.message, :unauthorized)
    end

    rescue_from ExceptionHandler::ExpiredSignature do |_e|
      render_error('You seem to have an expired token', :unauthorized)
    end
  end
end
