class AddWatershedSegmentIdToField < ActiveRecord::Migration
  def change
    add_column :fields, :watershed_segment_id, :integer
  end
end
