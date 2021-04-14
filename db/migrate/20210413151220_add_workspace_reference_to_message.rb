class AddWorkspaceReferenceToMessage < ActiveRecord::Migration[6.0]
  def change
    add_reference :messages, :workspace, null: false, foreign_key: true
  end
end
