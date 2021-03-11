class AddDocumentToWorkspace < ActiveRecord::Migration[6.0]
  def change
    add_column :workspaces, :document, :string
  end
end
