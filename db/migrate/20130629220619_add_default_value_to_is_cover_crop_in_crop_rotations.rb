class AddDefaultValueToIsCoverCropInCropRotations < ActiveRecord::Migration
  def change
    change_column :crop_rotations, :is_cover_crop, :boolean, :default => false, :null => false
  end
end
