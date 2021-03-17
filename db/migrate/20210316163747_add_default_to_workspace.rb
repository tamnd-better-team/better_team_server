class AddDefaultToWorkspace < ActiveRecord::Migration[6.0]
  def change
    change_column_default :workspaces, :is_private, from: nil, to: false
  end
end
