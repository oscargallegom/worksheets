class RenameProjectsToFarms < ActiveRecord::Migration
  def up
    rename_table :projects, :farms
    rename_table :animals_projects, :animals_farms
  end

  def down
  end
end

