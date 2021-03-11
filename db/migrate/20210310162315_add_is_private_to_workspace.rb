class AddIsPrivateToWorkspace < ActiveRecord::Migration[6.0]
  def change
    add_column :workspaces, :is_private, :boolean
  end
end
