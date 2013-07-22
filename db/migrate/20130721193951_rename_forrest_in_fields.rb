class RenameForrestInFields < ActiveRecord::Migration
  def change
    rename_column :fields, :is_forrest_buffer, :is_forest_buffer
    rename_column :fields, :forrest_buffer_average_width, :forest_buffer_average_width
    rename_column :fields, :forrest_buffer_length, :forest_buffer_length
    rename_column :fields, :is_forrest_buffer_planned, :is_forest_buffer_planned
  end
end
