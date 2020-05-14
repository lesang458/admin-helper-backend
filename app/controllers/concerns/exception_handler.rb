module ExceptionHandler
  include JsonResponseHandler
  extend ActiveSupport::Concern
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class Unauthorized < StandardError; end
  included do
    rescue_from ExceptionHandler::Unauthorized do
      render_error("Couldn't find user", :unauthorized)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render_error(e.full_message, :not_found)
    end

    rescue_from ExceptionHandler::DecodeError do |e|
      render_error(e.message, :unauthorized)
    end

    rescue_from ExceptionHandler::ExpiredSignature do |e|
      render_error(e.full_message, :unauthorized)
    end
  end
end
