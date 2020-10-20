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

  def render_collection(list, serializer_class = nil)
    if serializer_class.nil?
      render json: list, root: 'data', meta: list.respond_to?(:current_page) ? pagination_dict(list) : nil
    else
      render json: {
        data: list.map { |item| serializer_class.new(item) },
        meta: list.respond_to?(:current_page) ? pagination_dict(list) : nil
      }
    end
  end

  def render_resource(obj, status_code_symbol = :ok, serializer_class = nil)
    serializer_class.nil? ? (render json: obj, status: status_code_symbol) : (render json: { "#{obj.class.to_s.underscore}": serializer_class.new(obj) }, status: status_code_symbol)
  end

  def render_resources(objs, status_code_symbol, serializer_class = nil)
    serializer_class.nil? ? (render json: objs, status: status_code_symbol) : (render json: objs, each_serializer: serializer_class, status: status_code_symbol)
  end
end
