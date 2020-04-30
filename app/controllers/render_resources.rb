module RenderResources
  def render_resource(input, status = 200)
    render json: input, status: status
  end
end
