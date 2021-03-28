class AddLabelToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :label, :string
  end
end
