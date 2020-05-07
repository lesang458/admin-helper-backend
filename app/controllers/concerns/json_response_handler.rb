module JsonResponseHandler
  def render_error(error, symbol)
    render json: {
      status: Rack::Utils.status_code(symbol),
      message: error.full_message
    }, status: symbol
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
end
