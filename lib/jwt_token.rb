require 'jwt'
ALGORITHM = 'HS256'.freeze

module JwtToken
  def self.encode(payload, exp = 24.hours.from_now, secret)
    payload['exp'] = exp.to_i
    JWT.encode(payload, secret, ALGORITHM)
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
