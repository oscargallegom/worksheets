class ModifyTmdlWatershedInFields < ActiveRecord::Migration
  def change
    add_column :fields, :tmdl_id, :integer
    remove_column :fields, :tmdl_watershed
  end
end
