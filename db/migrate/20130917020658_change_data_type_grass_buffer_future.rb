class ChangeDataTypeGrassBufferFuture < ActiveRecord::Migration
  def change
    remove_column :fields, :grass_buffer_average_width_future
    remove_column :fields, :grass_buffer_length_future
    add_column :fields, :grass_buffer_average_width_future, :decimal
    add_column :fields, :grass_buffer_length_future, :decimal
  end
end
