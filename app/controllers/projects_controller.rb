class ProjectsController < ApplicationController

	before_action :set_project, only: [:update, :destroy]
  before_action :get_user, only:[:create]
  def index
	  if current_user.admin?
	    projects = Project.all
	  elsif current_user.manager?
	    projects = current_user.owned_projects
	  else
	    projects = current_user.projects
	  end

	  render json: projects
  end

  def create
    auth = authorize_service
    return render json: {error: "You are not authorized to create projects"}, status: :forbidden unless auth.can_create_project?
    
    begin
      project = Project.create!(project_params)
      render json: {project: project, message: "Project created successfully"}, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: {error: "Failed to create project", errors: e.record.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    return render json: {error: "You are not authorized to update this project"}, status: :forbidden unless authorize_service(@project).can_update_project?
    
    begin
      @project.update!(project_params)
      render json: {project: @project, message: "Project updated successfully"}, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: {error: "Failed to update project", errors: e.record.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    return render json: {error: "You are not authorized to delete this project"}, status: :forbidden unless authorize_service(@project).can_delete_project?
    @project.destroy
    render json: {message: "Project removed successfully"}, status: :ok
  end

  private

  def set_project
    @project = Project.find_by(id: params[:id])
    return @project if @project.present?
    render json: {error: "Project not found with id: #{params[:id]}"}, status: :not_found
    return
  end

  def get_user
  	@user = User.find_by(id: params[:owner_id])
  	return @user if @user.present?
  	render json: {error: "User not found with id: #{params[:owner_id]}"}, status: :unprocessable_entity
  	return
  end
  
  def project_params
  	params.require(:project).permit(:title, :description, :owner_id)
  end
end
