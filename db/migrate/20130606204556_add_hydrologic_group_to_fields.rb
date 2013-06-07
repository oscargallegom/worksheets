class AddHydrologicGroupToFields < ActiveRecord::Migration
  def change
    add_column :fields, :hydrologic_group, :string
    remove_column :soils, :hydrologic_group
  end
end
