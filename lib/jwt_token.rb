require 'jwt'

module JwtToken
  ALGORITHM = 'HS256'.freeze

  def self.render_secret_key_base
    Rails.application.credentials.secret_key_base
  end

  def self.encode(payload, exp = 24.hours.from_now)
    payload['exp'] = exp.to_i
    JWT.encode(payload, JwtToken.render_secret_key_base, ALGORITHM)
  end

  def self.render_user_authorized_token(payload)
    JwtToken.encode payload
  end

  def self.decode(token)
    body = JWT.decode(token, JwtToken.render_secret_key_base, { algorithm: ALGORITHM })[0]
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature
    raise ExceptionHandler::ExpiredSignature
  rescue JWT::DecodeError, JWT::VerificationError
    raise ExceptionHandler::DecodeError
  end
end
