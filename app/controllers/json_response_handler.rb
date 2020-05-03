module JsonResponseHandler
  def render_collection_employees(list_employees, status = 200)
    render json: {
      data: list_employees,
      status: status,
      pagination: {
        current_page: list_employees.current_page,
        page_size: list_employees.size,
        total_pages: list_employees.total_pages,
        total_count: list_employees.total_count
      }
    }
  end
end
