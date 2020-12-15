require 'googleauth/id_tokens'
module GoogleApis::IdTokens
  def self.get_user_info(id_token)
    Google::Auth::IDTokens.verify_oidc id_token
  rescue Google::Auth::IDTokens::SignatureError
    raise ExceptionHandler::InvalidIdToken
  rescue  Google::Auth::IDTokens::AudienceMismatchError
    raise ExceptionHandler::InvalidClientId
  rescue  Google::Auth::IDTokens::ExpiredTokenError
    raise ExceptionHandler::ExpiredToken
  end
end
