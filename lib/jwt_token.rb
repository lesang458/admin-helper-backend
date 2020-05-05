require 'jwt'
ALGORITHM = 'HS256'.freeze

module JwtToken
  def self.render_secret_key_base
    Rails.application.credentials.secret_key_base
  end

  def self.encode(payload, exp = 24.hours.from_now, secret)
    payload['exp'] = exp.to_i
    JWT.encode(payload, secret, ALGORITHM)
  end

  def self.render_user_authorized_token(payload, secret)
    JwtToken.encode payload, secret
  end

  def self.decode(token, secret)
    body = JWT.decode(token, secret, { algorithm: ALGORITHM })[0]
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature
    raise ExceptionHandler::ExpiredSignature
  rescue JWT::DecodeError, JWT::VerificationError
    raise ExceptionHandler::DecodeError
  end
end
