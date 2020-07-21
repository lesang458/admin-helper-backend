require 'google/apis/oauth2_v2'
module GetGoogleUserinfo
  def self.get_access_token(authorization_code)
    google = Google::Apis::Oauth2V2::Oauth2Service.new
    signet = Signet::OAuth2::Client.new(
      grant_type: 'authorization_code',
      authorization_uri:    'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://www.googleapis.com/oauth2/v3/token',
      client_id:            '632249869598-6ki4aqovptqpgl23slvsrtrft37mbmrm.apps.googleusercontent.com',
      client_secret:        '6Vx_XGOaLyF-7kqwRk4OcilN',
      scope:                'email profile', # if you need only the name and gender, feel free to remove the 'email' part
      redirect_uri:         'http://localhost:3000/api/v1/oauth/google_oauth2/callback', # it has to match the redirect_uri provided when obtaining the code from line 17
    )
    signet.code = authorization_code
    signet.fetch_access_token!
    google.authorization = signet
    google.get_userinfo_v2
    rescue Signet::AuthorizationError 
      raise ExceptionHandler::InvalidAuthorizationCode
  end
end