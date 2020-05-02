module JsonResponseHandler
  def self.render_unauthorized_error(_error)
    render json: {
      message: _error.full_message
    }, status: :unauthorized
  end
end
