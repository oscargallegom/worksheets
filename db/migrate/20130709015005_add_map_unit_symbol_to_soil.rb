class AddMapUnitSymbolToSoil < ActiveRecord::Migration
  def change
    add_column :soils, :map_unit_symbol, :string
    add_column :grazing_livestocks, :days_grazed, :integer
  end
end
