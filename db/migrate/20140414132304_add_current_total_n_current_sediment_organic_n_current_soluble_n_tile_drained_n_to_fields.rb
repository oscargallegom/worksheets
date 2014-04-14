class AddCurrentTotalNCurrentSedimentOrganicNCurrentSolubleNTileDrainedNToFields < ActiveRecord::Migration
  def change
    add_column :fields, :current_total_n, :float
    add_column :fields, :current_sediment_organic_n, :float
    add_column :fields, :current_soluble_n, :float
    add_column :fields, :tile_drained_n, :float
  end
end
