class AddNameToManureTypeCategory < ActiveRecord::Migration
  def change
    add_column :manure_type_categories, :name, :string
  end
end
