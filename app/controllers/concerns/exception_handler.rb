module ExceptionHandler
  include JsonResponseHandler
  extend ActiveSupport::Concern
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class Unauthorized < StandardError; end
  class BadRequest < StandardError; end
  class Forbidden < StandardError; end
  class TokenExpired < StandardError; end
  class InvalidAuthorizationCode < StandardError; end
  included do
    rescue_from ExceptionHandler::BadRequest, with: :bad_request
    rescue_from ExceptionHandler::TokenExpired, with: :token_expired
    rescue_from ExceptionHandler::InvalidAuthorizationCode, with: :invalid_authorization_code
    rescue_from ExceptionHandler::Unauthorized do |exception|
      render_error(exception.message, :unauthorized)
    end

    rescue_from ExceptionHandler::Forbidden do |exception|
      render_error(exception.message, :forbidden)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render_error(e.message, :not_found)
    end

    rescue_from ExceptionHandler::DecodeError do
      render_error('User authentication failed', :unauthorized)
    end

    rescue_from ExceptionHandler::ExpiredSignature do
      render_error('You seem to have an expired token', :unauthorized)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render_error(e.message, :unprocessable_entity)
    end

    rescue_from ArgumentError do |e|
      render_error(e.message, :unprocessable_entity)
    end
  end

  def bad_request(exception)
    render_bad_request_error(exception.message)
  end

  def token_expired
    render_error('You seem to have an expired token', :unauthorized)
  end

  def invalid_authorization_code
    render_bad_request_error('You seem to have an invalid authorization_code')
  end
end
