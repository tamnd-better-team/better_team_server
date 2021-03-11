class CreateTaskComments < ActiveRecord::Migration[6.0]
  def change
    create_table :task_comments do |t|
      t.string :content

      t.timestamps
    end
  end
end
