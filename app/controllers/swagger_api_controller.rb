class SwaggerApiController < ActionController::Base
  include HttpAuthConcern
  before_action :http_authenticate
  def index
    render inline: File.read('public/dist/index.html')
  end
end
