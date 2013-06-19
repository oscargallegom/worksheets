class CreateCropTypes < ActiveRecord::Migration
  def change
    create_table :crop_types do |t|
      t.text :name

      t.timestamps
    end
  end
end
