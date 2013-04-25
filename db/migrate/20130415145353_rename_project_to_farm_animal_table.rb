class RenameProjectToFarmAnimalTable < ActiveRecord::Migration
  def change
    rename_column :animals_farms, :project_id, :farm_id
  end
end
