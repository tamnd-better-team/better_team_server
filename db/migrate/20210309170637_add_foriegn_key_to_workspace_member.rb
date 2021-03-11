class AddForiegnKeyToWorkspaceMember < ActiveRecord::Migration[6.0]
  def change
    add_column :workspace_members, :workspace_id, :integer
    add_column :workspace_members, :user_id, :integer
  end
end
