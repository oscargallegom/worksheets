class AddAcresToFarmAndField < ActiveRecord::Migration
  def change
    add_column :farms, :acres, :float
    add_column :fields, :acres, :float
  end
end
