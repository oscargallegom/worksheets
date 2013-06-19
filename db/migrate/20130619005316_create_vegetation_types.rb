class CreateVegetationTypes < ActiveRecord::Migration
  def change
    create_table :vegetation_types do |t|
      t.string :name
    end
  end
end
