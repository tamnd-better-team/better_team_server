class AddCodeToWorkspace < ActiveRecord::Migration[6.0]
  def change
    add_column :workspaces, :code, :string
  end
end
