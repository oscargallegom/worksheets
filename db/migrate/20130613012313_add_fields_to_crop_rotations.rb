class AddFieldsToCropRotations < ActiveRecord::Migration
  def change
    add_column :crop_rotations, :is_cover_crop, :boolean
    add_column :crop_rotations, :cover_crop_id, :integer
    add_column :crop_rotations, :cover_crop_planting_method_id, :integer
  end
end
