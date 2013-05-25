class CreateCropRotations < ActiveRecord::Migration
  def change
    create_table :crop_rotations do |t|
      t.integer :crop_id
      t.date :plant_date
      t.integer :planting_method_id
      t.decimal :seeding_rate

      t.timestamps
    end
  end
end
