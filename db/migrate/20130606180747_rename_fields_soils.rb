class RenameFieldsSoils < ActiveRecord::Migration
  def change
    rename_column :soils, :mukey, :map_unit_key
    rename_column :soils, :compname, :component_name
    rename_column :soils, :muname, :map_unit_name

    add_column :soils, :hydrologic_group, :string

  end
end
