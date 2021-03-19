class WorkspaceMember < ApplicationRecord
  belongs_to :user
  belongs_to :workspace

  enum role: {member: 0, admin: 1}
  enum status: {approved: 0, pending: 1, rejected: 2}

  scope :by_user_workspace, (lambda do |user_id, workspace_id|
    where(user_id: user_id, workspace_id: workspace_id)
  end)
end
