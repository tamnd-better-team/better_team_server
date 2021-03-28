class ChangeLengthDescriptionOfTask < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :description, :string, :limit => 5000
  end
end
