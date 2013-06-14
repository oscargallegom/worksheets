class AddPlannedToFields < ActiveRecord::Migration
  def change
    add_column :fields, :is_forest_buffer_planned, :boolean
    add_column :fields, :is_grass_buffer_planned, :boolean
  end
end
