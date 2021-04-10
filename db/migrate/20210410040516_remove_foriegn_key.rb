class RemoveForiegnKey < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :workspace_id, :integer
    remove_column :workspace_members, :workspace_id, :integer
    remove_column :workspace_members, :user_id, :integer
    remove_column :messages, :user_id, :integer
    remove_column :messages, :workspace_id, :integer
    remove_column :task_comments, :task_id, :integer
    remove_column :task_comments, :user_id, :integer
    remove_column :task_labels, :task_id, :integer
    remove_column :task_histories, :task_id, :integer
    remove_column :task_histories, :user_id, :integer
  end
end
