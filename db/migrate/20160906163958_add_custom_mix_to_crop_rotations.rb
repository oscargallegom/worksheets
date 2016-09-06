class AddCustomMixToCropRotations < ActiveRecord::Migration
  def change
    add_column :crop_rotations, :mix_type_1, :integer
    add_column :crop_rotations, :mix_percent_1, :integer
    add_column :crop_rotations, :mix_type_2, :integer
    add_column :crop_rotations, :mix_percent_2, :integer
    add_column :crop_rotations, :mix_type_3, :integer
    add_column :crop_rotations, :mix_percent_3, :integer
  end
end
