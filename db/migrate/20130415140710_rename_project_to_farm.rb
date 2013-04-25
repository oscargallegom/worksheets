class RenameProjectToFarm < ActiveRecord::Migration
  def change
    rename_table :projects, :farms
  end
end
