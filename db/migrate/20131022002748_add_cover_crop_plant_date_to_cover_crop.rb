class AddCoverCropPlantDateToCoverCrop < ActiveRecord::Migration
  def change
    add_column :crop_rotations, :cover_crop_plant_date_year, :integer
    add_column :crop_rotations, :cover_crop_plant_date_month, :integer
    add_column :crop_rotations, :cover_crop_plant_date_day, :integer
  end
end
