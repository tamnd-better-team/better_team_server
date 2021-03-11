class AddForiegnKeyToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :user_id, :integer
    add_column :messages, :workspace_id, :integer
  end
end
