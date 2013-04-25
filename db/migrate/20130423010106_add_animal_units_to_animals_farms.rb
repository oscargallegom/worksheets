class AddAnimalUnitsToAnimalsFarms < ActiveRecord::Migration
  def change
    add_column :animals_farms, :animals_units, :decimal
  end
end
