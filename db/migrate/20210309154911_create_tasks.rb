class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :completion, default: 0
      t.integer :priority, default: 0
      t.date :start_date
      t.date :due_date
      t.string :title
      t.string :description
      t.string :type
      t.integer :status, default: 0
      t.integer :percentage_completed

      t.timestamps
    end
  end
end
