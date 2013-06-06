class RemoveSegmentFromField < ActiveRecord::Migration
  def change
    remove_column :fields, :segment_id
  end


end
