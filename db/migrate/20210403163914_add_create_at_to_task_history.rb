class AddCreateAtToTaskHistory < ActiveRecord::Migration[6.0]
  def change
    add_column :task_histories, :created_at, :datetime
  end
end
