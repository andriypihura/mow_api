class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authenticate_request
  attr_reader :current_user

  private

  def find_current_user
    @current_user = AuthorizeApiRequest.call(request.headers).result
  end

  def authenticate_request
    find_current_user
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
