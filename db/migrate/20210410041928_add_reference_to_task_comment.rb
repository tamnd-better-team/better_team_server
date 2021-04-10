class AddReferenceToTaskComment < ActiveRecord::Migration[6.0]
  def change
    add_reference :task_comments, :user, null: false, foreign_key: true
    add_reference :task_comments, :task, null: false, foreign_key: true
  end
end
