class RenameProjectAnimalsTable < ActiveRecord::Migration
  def change
    rename_table :projects_animals, :animals_projects
  end
end
