class CreateTaskLabel < ActiveRecord::Migration[6.0]
  def change
    create_table :task_labels do |t|
      t.integer :task_id
      t.string :color
      t.string :text
    end
  end
end
