class AddBufferToFields < ActiveRecord::Migration
  def change
    add_column :fields, :is_forest_buffer, :boolean
    add_column :fields, :forest_buffer_average_width, :decimal
    add_column :fields, :forest_buffer_length, :decimal
    add_column :fields, :forest_buffer_area, :decimal
    add_column :fields, :is_forest_buffer_planned, :boolean

    add_column :fields, :is_grass_buffer, :boolean
    add_column :fields, :grass_buffer_average_width, :decimal
    add_column :fields, :grass_buffer_length, :decimal
    add_column :fields, :grass_buffer_area, :decimal
    add_column :fields, :is_grass_buffer_planned, :boolean

    add_column :fields, :is_wetland, :boolean
    add_column :fields, :wetland_area, :decimal
    add_column :fields, :wetland_treated_area, :decimal
    add_column :fields, :is_wetland_planned, :boolean
  end
end
