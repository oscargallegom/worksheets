class AddSegmentIdToFields < ActiveRecord::Migration
  def change
    add_column :fields, :segment_id, :string
  end
end
