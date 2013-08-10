class AddFieldsToWatershedSegmentTable < ActiveRecord::Migration
  def change
    add_column :watershed_segments, :cafo_eos_sediment, :decimal
    add_column :watershed_segments, :cafo_n_rf, :decimal
    add_column :watershed_segments, :cafo_p_rf, :decimal
  end
end
