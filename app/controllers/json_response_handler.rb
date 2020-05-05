module JsonResponseHandler
  def render_collection(list)
    render json: {
      data: list.map { |employee| EmployeeSerializer.new(employee) },
      pagination: {
        current_page: list.current_page,
        page_size: list.size,
        total_pages: list.total_pages,
        total_count: list.total_count
      }
    }
  end
end
