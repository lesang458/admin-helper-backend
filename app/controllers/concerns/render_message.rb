module RenderMessage
  def self.invalid_token
    render json: {
      message: 'Access denied!. Invalid token supplied.'
    }, status: :unauthorized
  end

  def self.expired_token
    render json: {
      message: 'Access denied!. Token has expired.'
    }, status: :unauthorized
  end
end
