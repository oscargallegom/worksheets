class CreateCrops < ActiveRecord::Migration
  def change
    create_table :crops do |t|
      t.string :name
      t.integer :crop_category_id
    end
  end
end
