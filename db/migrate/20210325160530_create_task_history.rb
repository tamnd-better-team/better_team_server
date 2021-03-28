class CreateTaskHistory < ActiveRecord::Migration[6.0]
  def change
    create_table :task_histories do |t|
      t.integer :user_id
      t.integer :task_id
      t.string :field
      t.string :value_before
      t.string :value_after
    end
  end
end
