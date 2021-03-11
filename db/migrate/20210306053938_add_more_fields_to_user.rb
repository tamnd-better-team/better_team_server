class AddMoreFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sex, :string
    add_column :users, :avatar, :string
    add_column :users, :birthday, :date
  end
end
