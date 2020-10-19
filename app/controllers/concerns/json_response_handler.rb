module JsonResponseHandler
  def render_error(message, status_code_symbol)
    render json: {
      status: Rack::Utils.status_code(status_code_symbol),
      message: message
    }, status: status_code_symbol
  end

  def render_bad_request_error(message)
    render_error message, :bad_request
  end

  def render_collection(list, _serializer_class = nil)
    render json: list, root: 'data', meta: pagination_dict(list)
  end

  def render_resource(obj, status_code_symbol, _serializer_class = nil)
    render json: obj, status: status_code_symbol
  end

  def render_resources(objs, status_code_symbol, _serializer_class = nil)
    render json: objs, status: status_code_symbol
  end
end
