module ExceptionHandler
  include JsonResponseHandler
  extend ActiveSupport::Concern
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class Unauthorized < StandardError; end
  class BadRequest < StandardError; end
  class Forbidden < StandardError; end
  class InvalidIdToken < StandardError; end
  class ExpiredToken < StandardError; end
  class InvalidClientId < StandardError; end

  class InvalidAuthorizationCode < StandardError; end
  included do
    rescue_from ExceptionHandler::BadRequest, with: :bad_request
    rescue_from ExceptionHandler::InvalidAuthorizationCode, with: :invalid_authorization_code
    rescue_from ExceptionHandler::InvalidIdToken, with: :invalid_token
    rescue_from ExceptionHandler::InvalidClientId, with: :invalid_client_id
    rescue_from ExceptionHandler::ExpiredToken, with: :expired_token
    rescue_from ExceptionHandler::DecodeError, with: :decode_error
    rescue_from ExceptionHandler::ExpiredSignature, with: :expired_token
    rescue_from ExceptionHandler::Unauthorized do |exception|
      render_error(exception.message, :unauthorized)
    end

    rescue_from ExceptionHandler::Forbidden do |exception|
      render_error(exception.message, :forbidden)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render_error(e.message, :not_found)
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

  def invalid_authorization_code
    render_bad_request_error('You seem to have an invalid authorization_code')
  end

  def invalid_token
    render_error('You seem to have an invalid token', :unauthorized)
  end

  def expired_token
    render_error('You seem to have an expired token', :unauthorized)
  end

  def invalid_client_id
    render_error('You seem to have an invalid client_id', :unauthorized)
  end

  def decode_error
    render_error('User authentication failed', :unauthorized)
  end
end
