class AuthorizeApiRequest
  def initialize(token)
    @token = token.split(' ')[1] if token.present?
  end

  def current_user
    user = User.find_by(id: decode_auth_token[:user_id])
    raise(ExceptionHandler::Unauthorized, 'User authentication failed') unless user
    user
  end

  private

  def decode_auth_token
    @decode_auth_token = JwtToken.decode(@token)
  end
end
