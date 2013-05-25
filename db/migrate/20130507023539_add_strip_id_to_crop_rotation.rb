class AddStripIdToCropRotation < ActiveRecord::Migration
  def change
    add_column :crop_rotations, :strip_id, :integer
  end
end
