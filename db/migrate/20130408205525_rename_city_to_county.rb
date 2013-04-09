class RenameCityToCounty < ActiveRecord::Migration
  def change
    rename_table :cities, :counties
  end
end
