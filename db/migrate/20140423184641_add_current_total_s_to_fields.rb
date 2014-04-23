class AddCurrentTotalSToFields < ActiveRecord::Migration
  def change
    add_column :fields, :current_total_n, :float
    add_column :fields, :current_sediment_organic_n, :float
    add_column :fields, :current_soluble_n, :float
    add_column :fields, :tile_drained_n, :float
    add_column :fields, :current_total_p, :float
    add_column :fields, :current_sediment_organic_p, :float
    add_column :fields, :current_soluble_p, :float
    add_column :fields, :tile_drained_p, :float
    add_column :fields, :future_total_n, :float
    add_column :fields, :future_sediment_organic_n, :float
    add_column :fields, :future_soluble_n, :float
    add_column :fields, :future_tile_drained_n, :float
    add_column :fields, :future_total_p, :float
    add_column :fields, :future_sediment_organic_p, :float
    add_column :fields, :future_tile_drained_p, :float
    add_column :fields, :current_flow, :float
    add_column :fields, :future_flow, :float
    add_column :fields, :current_sediment, :float
    add_column :fields, :future_sediment, :float
    add_column :fields, :current_carbon, :float
    add_column :fields, :future_carbon, :float
  end
end
