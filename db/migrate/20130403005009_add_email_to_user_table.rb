class AddEmailToUserTable < ActiveRecord::Migration
  def change
    add_column :users, :email, :string, :null => false
  end
end
