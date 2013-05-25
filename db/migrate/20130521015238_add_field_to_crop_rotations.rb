class AddFieldToCropRotations < ActiveRecord::Migration
  def change
    add_column :crop_rotations, :crop_end_of_season_id, :integer
  end
end
