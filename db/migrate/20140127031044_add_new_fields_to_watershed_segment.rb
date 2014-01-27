class AddNewFieldsToWatershedSegment < ActiveRecord::Migration
  def change
    rename_column :watershed_segments, :n_adjust, :n_crop_adjust
    rename_column :watershed_segments, :p_adjust, :p_crop_adjust
    rename_column :watershed_segments, :sediment_adjust, :sediment_crop_adjust

    add_column :watershed_segments, :n_hay_adjust, :decimal
    add_column :watershed_segments, :p_hay_adjust, :decimal
    add_column :watershed_segments, :sediment_hay_adjust, :decimal

    add_column :watershed_segments, :n_pasture_adjust, :decimal
    add_column :watershed_segments, :p_pasture_adjust, :decimal
    add_column :watershed_segments, :sediment_pasture_adjust, :decimal
  end
end
