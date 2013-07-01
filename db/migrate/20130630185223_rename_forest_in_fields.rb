class RenameForestInFields < ActiveRecord::Migration
  def change
    rename_column :fields, :is_forest_buffer, :is_forrest_buffer
    rename_column :fields, :forest_buffer_average_width, :forrest_buffer_average_width
    rename_column :fields, :forest_buffer_length, :forrest_buffer_length
    rename_column :fields, :is_forest_buffer_planned, :is_forrest_buffer_planned
  end
end
