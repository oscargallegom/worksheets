class AddGroundCoverToCropRotations < ActiveRecord::Migration
  def change
    add_column :crop_rotations, :ground_cover, :integer
  end
end
