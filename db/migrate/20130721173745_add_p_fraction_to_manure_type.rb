class AddPFractionToManureType < ActiveRecord::Migration
  def change
    add_column :manure_types, :p_fraction, :decimal
    remove_column :manure_fertilizer_applications, :p_fraction
  end
end
