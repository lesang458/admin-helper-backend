class AuthorizeApiRequest
  def initialize(headers)
    @headers = headers
  end

  def current_users
    {
      user: user
    }
  end

  private

  attr_reader :headers

  def user
    User.find(decode_auth_token[:id])
  end

  def decode_auth_token
    @decode_auth_token = JwtToken.decode(headers, 'ccdane')
  end
end
