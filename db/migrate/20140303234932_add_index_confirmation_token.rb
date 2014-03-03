class AddIndexConfirmationToken < ActiveRecord::Migration
  def change
    remove_index :users, :confirmation_token
    add_index :users, :confirmation_token, :unique => false
  end
end
