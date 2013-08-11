class AddDebugFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_debug_mode, :boolean, :default => false
  end
end
