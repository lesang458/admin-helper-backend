class ApplicationController < ActionController::API
  include JsonResponseHandler
  include ExceptionHandler
  include JwtToken
  include Authenticatable
  before_action :authorize_request

  def set_paginate
    @per_page = params[:per_page] || 20
    @page = params[:page] || 1
  end
end
