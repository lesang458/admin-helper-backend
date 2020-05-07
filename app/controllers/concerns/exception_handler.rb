module ExceptionHandler
  include JsonResponseHandler
  extend ActiveSupport::Concern
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class WrongPassword < StandardError; end
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render_error(e, :not_found)
    end

    rescue_from ExceptionHandler::DecodeError do |e|
      render_error(e, :unauthorized)
    end

    rescue_from ExceptionHandler::ExpiredSignature do |e|
      render_error(e, :unauthorized)
    end

    rescue_from ExceptionHandler::WrongPassword, with: :render_unprocessable_entity_error
  end

  private

  def render_unprocessable_entity_error
    render json: {
      error: {
        status: '422',
        masseage: 'wrong password'
      }
    }
  end
end
