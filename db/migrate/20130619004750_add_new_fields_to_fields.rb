class AddNewFieldsToFields < ActiveRecord::Migration
  def change
    add_column :fields, :is_pasture_adjacent_to_stream, :boolean
    add_column :fields, :is_streambank_fencing_in_place, :boolean
    add_column :fields, :distance_fence_stream, :decimal
    add_column :fields, :fence_length, :decimal
    add_column :fields, :vegetation_type_fence_stream_id, :integer
  end
end
