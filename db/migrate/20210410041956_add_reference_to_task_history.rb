class AddReferenceToTaskHistory < ActiveRecord::Migration[6.0]
  def change
    add_reference :task_histories, :user, null: false, foreign_key: true
    add_reference :task_histories, :task, null: false, foreign_key: true
  end
end
