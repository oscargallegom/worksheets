class RenameFieldCropEndOfSeason < ActiveRecord::Migration
  def change
    rename_column :crop_end_of_seasons, :crop_end_of_season_id, :crop_rotation_id
  end
end
