class AuthorizeApiRequest
  def initialize(token)
    @token = token
  end

  def current_user
    User.find(decode_auth_token[:user_id])
  end

  private

  attr_reader :headers

  def decode_auth_token
    @decode_auth_token = JwtToken.decode(token)
  end
end
