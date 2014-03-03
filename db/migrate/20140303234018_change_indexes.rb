class ChangeIndexes < ActiveRecord::Migration
  def change
  	remove_index :users, :reset_password_token
    add_index :users, :reset_password_token, :unique => false
  end
end
