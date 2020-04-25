require 'jwt'

module jwt_module
  secret = Rails.application.secrets.secret_key_base
  def encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, secret)
  end

  def decode(token)
    body = JWT.decode(token, secret)
  rescue
    nil
  end
end