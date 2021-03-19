class AddStatusToWorkspaceMember < ActiveRecord::Migration[6.0]
  def change
    add_column :workspace_members, :status, :integer, default: 0
  end
end
