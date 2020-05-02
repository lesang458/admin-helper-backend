module JsonResponseHandler
  def self.render_unauthorized_error(error)
    render json: {
      message: error.full_message
    }, status: :unauthorized
  end
end
