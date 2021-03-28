class RemoveCompletionFromTask < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :completion, :integer
  end
end
