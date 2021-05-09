class ChangeLengthOfWorkspaceDesc < ActiveRecord::Migration[6.0]
  def change
    change_column :workspaces, :description, :string, :limit => 5000
  end
end
