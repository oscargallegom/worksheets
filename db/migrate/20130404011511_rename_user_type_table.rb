class RenameUserTypeTable < ActiveRecord::Migration
  def change
    rename_table :user_type, :user_types
  end
end
