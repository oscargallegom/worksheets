class RenameFieldsInFields < ActiveRecord::Migration
  def change
    rename_column :fields, :acres, :acres_from_user
    rename_column :fields, :acres_use_map, :is_acres_from_map
  end
end
