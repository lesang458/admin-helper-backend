module HttpAuthConcern
  extend ActiveSupport::Concern

  def http_authenticate
    return true unless Rails.env == 'development' || Rails.env == 'production'
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials.ADMIN_USER && password == Rails.application.credentials.ADMIN_PASS
    end
  end
end
