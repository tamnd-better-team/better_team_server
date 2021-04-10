class AddReferenceToWorkspaceMember < ActiveRecord::Migration[6.0]
  def change
    add_reference :workspace_members, :user, null: false, foreign_key: true
    add_reference :workspace_members, :workspace, null: false, foreign_key: true
  end
end
