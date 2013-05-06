class AddFieldsToFields < ActiveRecord::Migration
  def change
    add_column :fields, :tmdl_watershed, :boolean
    add_column :fields, :field_type_id, :integer
    add_column :fields, :notes, :text
    add_column :fields, :segment_id, :integer
    add_column :fields, :acres_from_map, :decimal
    add_column :fields, :acres_use_map, :boolean
    add_column :fields, :tile_drainage_depth, :decimal
    add_column :fields, :irrigation_id, :integer
    add_column :fields, :fertigation_n, :decimal
    add_column :fields, :p_test_method_id, :integer
    add_column :fields, :p_test_value, :decimal
  end
end
