require 'google/apis/oauth2_v2'
module GoogleApis::Oauth2
  def self.get_user_info(authorization_code)
    google = Google::Apis::Oauth2V2::Oauth2Service.new
    signet = GoogleApis::Oauth2.response_signet
    signet.code = authorization_code
    signet.fetch_access_token!
    google.authorization = signet
    google.get_userinfo_v2
  rescue Signet::AuthorizationError
    raise ExceptionHandler::InvalidAuthorizationCode
  end

  def self.response_signet
    Signet::OAuth2::Client.new(
      grant_type: 'authorization_code',
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://www.googleapis.com/oauth2/v3/token',
      client_id: Rails.application.credentials.CLIENT_ID,
      client_secret: Rails.application.credentials.CLIENT_SECRET,
      scope: 'email profile',
      redirect_uri: Rails.application.config.redirect_uri_callback
    )
  end
end
