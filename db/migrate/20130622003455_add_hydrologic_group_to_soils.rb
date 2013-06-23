class AddHydrologicGroupToSoils < ActiveRecord::Migration
  def change
    add_column :soils, :hydrologic_group, :string
    remove_column :fields, :hydrologic_group
  end
end
