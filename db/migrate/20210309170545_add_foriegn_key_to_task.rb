class AddForiegnKeyToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :workspace_id, :integer
    add_column :tasks, :created_user_id, :integer
    add_column :tasks, :assigned_user_id, :integer
  end
end
