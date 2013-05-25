class AddEndOfSeasonToCropRotation < ActiveRecord::Migration
  def change
    add_column :crop_rotations, :end_of_season_year, :integer
    add_column :crop_rotations, :end_of_season_month, :integer
    add_column :crop_rotations, :end_of_season_day, :integer

    drop_table :crop_end_of_seasons
  end
end
