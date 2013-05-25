class AddCropRotationIdToHarvestOperations < ActiveRecord::Migration
  def change
    add_column :harvest_operations, :crop_rotation_id, :integer
  end
end
