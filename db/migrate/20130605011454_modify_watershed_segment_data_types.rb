class ModifyWatershedSegmentDataTypes < ActiveRecord::Migration
  def change
    change_column :watershed_segments, :description, :string
    change_column :watershed_segments, :major_basin, :string
    change_column :watershed_segments, :trib_strat_basin, :string
  end
end
