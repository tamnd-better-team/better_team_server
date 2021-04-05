class ChangeFieldsLengthOfTaskHistory < ActiveRecord::Migration[6.0]
  def change
    change_column :task_histories, :value_before, :string, :limit => 5000
    change_column :task_histories, :value_after, :string, :limit => 5000
  end
end
