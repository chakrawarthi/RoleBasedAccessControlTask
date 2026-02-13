class ProjectMembership < ApplicationRecord

    enum role: {
    viewer: "viewer",
    editor: "editor"
  }
  
  validates :role, presence: true, inclusion: {in: roles.keys}
  validates :user_id, uniqueness: {scope: :project_id, message: "User is already a member of this project"}

  belongs_to :user
  belongs_to :project
end
