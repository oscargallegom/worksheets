class ChangeDefaultValueToApproveAttribute < ActiveRecord::Migration
  def change
    change_column :users, :approved, :boolean, :default => true
  end
end
