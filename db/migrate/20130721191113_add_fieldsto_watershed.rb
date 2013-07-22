class AddFieldstoWatershed < ActiveRecord::Migration
  def change
    add_column :watershed_segments, :total_n_forest, :decimal
    add_column :watershed_segments, :total_n_hyo, :decimal
    add_column :watershed_segments, :total_n_trp, :decimal

    add_column :watershed_segments, :total_p_forest, :decimal
    add_column :watershed_segments, :total_p_hyo, :decimal
    add_column :watershed_segments, :total_p_trp, :decimal

    add_column :watershed_segments, :total_sediment_forest, :decimal
    add_column :watershed_segments, :total_sediment_hyo, :decimal
    add_column :watershed_segments, :total_sediment_trp, :decimal

    add_column :watershed_segments, :n_delivery_factor, :decimal
    add_column :watershed_segments, :p_delivery_factor, :decimal
    add_column :watershed_segments, :sediment_delivery_total, :decimal
  end
end
