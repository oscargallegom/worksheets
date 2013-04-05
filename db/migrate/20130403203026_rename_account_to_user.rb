class RenameAccountToUser < ActiveRecord::Migration
  def up
    rename_table :accounts, :users
  end

  def down
  end
end
