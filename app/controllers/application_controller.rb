class ApplicationController < ActionController::API

  before_action :authenticate_user!

  private

  def current_user
    @current_user ||= User.find_by(id: request.headers["x-user-id"])
  end

  def authenticate_user!
    return if current_user.present?
    render json: { message: "can't find the user with id: #{request.headers["x-user-id"]}" },status: :unprocessable_entity
  end

  def authorize_service(project_details = nil)
    AuthorizationService.new(current_user, project_details)
  end

end
