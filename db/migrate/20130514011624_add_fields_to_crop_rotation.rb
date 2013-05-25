class AddFieldsToCropRotation < ActiveRecord::Migration
  def change
    add_column :crop_rotations, :plant_date_year, :integer
    add_column :crop_rotations, :plant_date_month, :integer
    add_column :crop_rotations, :plant_date_day, :integer
    remove_column :crop_rotations, :plant_date
  end
end
