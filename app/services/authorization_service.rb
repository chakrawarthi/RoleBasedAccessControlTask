class AuthorizationService
  def initialize(user, project_details = nil)
    @user   = user
    @record = project_details
  end

  def can_create_project?
    @user.admin?
  end

  def can_update_project?
    return true if @user.admin?
    return true if owner?
    editor_member?
  end

  def can_delete_project?
    @user.admin? || owner?
  end

  def can_manage_members?
    @user.admin? || owner?
  end

  private

  def owner?
    return false unless @record
    @record.owner_id == @user.id
  end

  def editor_member?
    return false unless @record
    membership = @record.project_memberships.find_by(user_id: @user.id)
    membership&.editor?
  end
end
