class RenameFieldsInSoils < ActiveRecord::Migration
  def change
    rename_column :soils, :clay, :percent_clay
    rename_column :soils, :sand, :percent_sand
    rename_column :soils, :silt, :percent_silt
  end
end
