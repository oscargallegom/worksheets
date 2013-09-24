class AddComponentNameToSoil < ActiveRecord::Migration
  def change
    add_column :soils, :component_name, :string
  end
end
