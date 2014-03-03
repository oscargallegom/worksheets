class ChangeUnlockToken < ActiveRecord::Migration
  def change
    remove_index :users, :unlock_token
    add_index :users, :unlock_token, :unique => false
  end
end
