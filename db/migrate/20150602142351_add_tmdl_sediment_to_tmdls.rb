class AddTmdlSedimentToTmdls < ActiveRecord::Migration
  def change
    add_column :tmdls, :total_s_crop, :float
    add_column :tmdls, :total_s_hay, :float
    add_column :tmdls, :total_s_pasture, :float
  end
end
