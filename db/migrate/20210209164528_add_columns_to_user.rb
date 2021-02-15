class AddColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string, default: ""
    add_column :users, :last_name, :string, default: ""
    add_column :users, :university, :string, default: ""
    add_column :users, :phone_number, :string, default: ""
    add_column :users, :address, :string, default: ""
    add_column :users, :facebook, :string, default: ""
  end
end
