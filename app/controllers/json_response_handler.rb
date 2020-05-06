module JsonResponseHandler
  def render_collection(list, name_class)
    render json: {
      data: list.map { |serializer| name_class.new(serializer) },
      pagination: {
        current_page: list.current_page,
        page_size: list.size,
        total_pages: list.total_pages,
        total_count: list.total_count
      }
    }
  end
end
