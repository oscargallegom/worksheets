class UpdateCropRotations < ActiveRecord::Migration
  def change
    remove_column :crop_rotations, :crop_end_of_season_id
    add_column :crop_end_of_seasons, :crop_rotation_id, :integer
    rename_column :crop_end_of_seasons, :start_date_year, :year
    rename_column :crop_end_of_seasons, :start_date_month, :month
    rename_column :crop_end_of_seasons, :start_date_day, :day
  end
end
