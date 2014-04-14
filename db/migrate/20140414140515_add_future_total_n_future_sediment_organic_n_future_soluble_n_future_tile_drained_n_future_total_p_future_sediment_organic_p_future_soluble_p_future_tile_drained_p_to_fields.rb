class AddFutureTotalNFutureSedimentOrganicNFutureSolubleNFutureTileDrainedNFutureTotalPFutureSedimentOrganicPFutureSolublePFutureTileDrainedPToFields < ActiveRecord::Migration
  def change
    add_column :fields, :future_total_n, :float
    add_column :fields, :future_sediment_organic_n, :float
    add_column :fields, :future_soluble_n, :float
    add_column :fields, :future_tile_drained_n, :float
    add_column :fields, :future_total_p, :float
    add_column :fields, :future_sediment_organic_p, :float
    add_column :fields, :future_soluble_p, :float
    add_column :fields, :future_tile_drained_p, :float
  end
end
