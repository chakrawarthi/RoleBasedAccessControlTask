class User < ApplicationRecord

	enum role: {
		admin: "admin",
		manager: "manager",
		member: "member"
	}
  
  validates :role, presence: true, inclusion:{in: roles.keys}

  has_many :owned_projects, class_name: "Project", foreign_key: "owner_id"
  has_many :project_memberships
  has_many :projects, through: :project_memberships
end
