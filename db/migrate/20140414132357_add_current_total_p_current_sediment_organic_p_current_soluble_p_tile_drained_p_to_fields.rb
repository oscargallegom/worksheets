class AddCurrentTotalPCurrentSedimentOrganicPCurrentSolublePTileDrainedPToFields < ActiveRecord::Migration
  def change
    add_column :fields, :current_total_p, :float
    add_column :fields, :current_sediment_organic_p, :float
    add_column :fields, :current_soluble_p, :float
    add_column :fields, :tile_drained_p, :float
  end
end
