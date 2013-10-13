class FieldSlope < ActiveRecord::Migration
  def change
    add_column :fields, :slope, :decimal
    remove_column :soil_textures, :slope
  end
end
