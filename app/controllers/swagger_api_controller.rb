class SwaggerApiController < ActionController::Base
  def index
    render inline: File.read('public/dist/index.html')
  end
end
