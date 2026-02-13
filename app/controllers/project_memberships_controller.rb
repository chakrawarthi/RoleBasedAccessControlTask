class ProjectMembershipsController < ApplicationController

  before_action :set_project
	before_action :get_user, only: [:create]

  def create
    unless authorize_service(@project).can_manage_members?
	    return render json: {
	      error: "You are not authorized to add members to this project"
	    }, status: :forbidden
  	end
		unless ProjectMembership.roles.keys.include?(params[:project_memberships][:role])
		  return render json: { error: "Role is invalid. Allowed roles: viewer, editor" }, status: :unprocessable_entity
		end
		
		begin
      membership = @project.project_memberships.create!(project_membership_params)
      render json: {membership: membership, message: "Member added successfully"}, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: {error: "Failed to add member", errors: e.record.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    return render json: {error: "You are not authorized to remove members from this project"}, status: :forbidden unless authorize_service(@project).can_manage_members?
    membership = @project.project_memberships.find_by(user_id: params[:user_id])
    if membership.present?
      membership.destroy
    	render json: {message: "Member removed successfully"}, status: :ok
    else
			render json: {error: "Member not found in this project"}, status: :not_found
		end
  end

  private

  def set_project
    @project = Project.find_by(id: params[:id])
    return @project if @project.present?
    render json: {error: "Project not found with id: #{params[:id]}"}, status: :not_found
    return
  end

  def get_user
  	@user = User.find_by(id: params[:project_memberships][:user_id])
  	return @user if @user.present?
  	render json: {error: "User not found with id: #{params[:user_id]}"}, status: :unprocessable_entity
  	return
  end
  def project_membership_params
  	params.require(:project_memberships).permit(:user_id, :role)
  end
end
