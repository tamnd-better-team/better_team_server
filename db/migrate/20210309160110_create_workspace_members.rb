class CreateWorkspaceMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :workspace_members do |t|
      t.string :role, default: 0

      t.timestamps
    end
  end
end
