class CreateCropCategories < ActiveRecord::Migration
  def change
    create_table :crop_categories do |t|
      t.string :name
    end
  end
end
