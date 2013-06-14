class RemoveBufferAreaFromFields < ActiveRecord::Migration
  def change
    remove_column :fields, :forest_buffer_area
    remove_column :fields, :grass_buffer_area
  end
end
