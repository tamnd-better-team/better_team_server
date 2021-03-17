class AddRoleToWorkspaceMember < ActiveRecord::Migration[6.0]
  def change
    change_column :workspace_members, :role, :integer, default: 0
  end
end
