module HttpAuthConcern
  extend ActiveSupport::Concern

  def http_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials.SWAGGER_USER.to_s && password == Rails.application.credentials.SWAGGER_PASSWORD.to_s
    end
  end
end
