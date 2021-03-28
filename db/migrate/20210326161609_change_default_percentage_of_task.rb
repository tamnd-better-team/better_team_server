class ChangeDefaultPercentageOfTask < ActiveRecord::Migration[6.0]
  def change
    change_column_default :tasks, :percentage_completed, from: nil, to: 0
  end
end
