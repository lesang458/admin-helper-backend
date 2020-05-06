module JsonResponseHandler
  def self.render_unauthorized_error(error)
    render json: {
      message: error.full_message
    }, status: :unauthorized
  end

  def self.render_not_found_error(error)
    render json: {
      message: error.full_message
    }, status: :not_found
  end
end
