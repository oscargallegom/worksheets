class RenameDeliveryFactor < ActiveRecord::Migration
  def change
    rename_column :watershed_segments, :sediment_delivery_total, :sediment_delivery_factor
  end
end
