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

  def render_collection(list, serializer_class)
    render json: {
      data: list.map { |item| serializer_class.new(item) },
      pagination: {
        current_page: list.current_page,
        page_size: list.size,
        total_pages: list.total_pages,
        total_count: list.total_count
      }
    }
  end

  def render_resource(name_response, obj, status_code_symbol, serializer_class)
    render json: { "#{name_response}": serializer_class.new(obj) }, status: status_code_symbol
  end

  def render_resources(objs, status_code_symbol, serializer_class)
    render json: objs, each_serializer: serializer_class, adapter: :json, status: status_code_symbol
  end
end
