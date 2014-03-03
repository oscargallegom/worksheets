class ChangeIndexAuthenticationToken < ActiveRecord::Migration
    def change
    remove_index :users, :authentication_token
    add_index :users, :authentication_token, :unique => false
  end
end
