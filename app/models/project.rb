class Project < ApplicationRecord

  belongs_to :owner, class_name: "User"
  has_many :project_memberships, dependent: :destroy
  has_many :users, through: :project_memberships

end
