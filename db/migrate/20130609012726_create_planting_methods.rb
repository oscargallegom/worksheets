class CreatePlantingMethods < ActiveRecord::Migration
  def change
    create_table :planting_methods do |t|
      t.string :name
    end
  end
end
