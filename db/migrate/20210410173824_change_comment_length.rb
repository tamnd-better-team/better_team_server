class ChangeCommentLength < ActiveRecord::Migration[6.0]
  def change
    change_column :task_comments, :content, :string, :limit => 5000
  end
end
