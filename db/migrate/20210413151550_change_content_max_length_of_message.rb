class ChangeContentMaxLengthOfMessage < ActiveRecord::Migration[6.0]
  def change
    change_column :messages, :content, :string, :limit => 5000
  end
end
