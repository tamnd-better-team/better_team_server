class WorkspaceMember < ApplicationRecord
  belongs_to :user
  belongs_to :workspace

  enum role: {member: 0, admin: 1}
end
