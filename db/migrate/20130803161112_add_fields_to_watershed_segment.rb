class AddFieldsToWatershedSegment < ActiveRecord::Migration
  def change
    add_column :watershed_segments, :n_crop_baseline, :decimal
    add_column :watershed_segments, :n_pasture_baseline, :decimal
    add_column :watershed_segments, :n_hay_baseline, :decimal

    add_column :watershed_segments, :p_crop_baseline, :decimal
    add_column :watershed_segments, :p_pasture_baseline, :decimal
    add_column :watershed_segments, :p_hay_baseline, :decimal

    add_column :watershed_segments, :sediment_crop_baseline, :decimal
    add_column :watershed_segments, :sediment_pasture_baseline, :decimal
    add_column :watershed_segments, :sediment_hay_baseline, :decimal

    add_column :watershed_segments, :n_adjust, :decimal
    add_column :watershed_segments, :p_adjust, :decimal
    add_column :watershed_segments, :sediment_adjust, :decimal
  end
end
