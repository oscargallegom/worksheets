class AddRequirementsToFields < ActiveRecord::Migration
  def change
    add_column :fields, :is_livestock_implemented_nutrient_plan, :boolean
    add_column :fields, :is_livestock_implemented_soil_water_plan, :boolean
    add_column :fields, :is_livestock_properly_sized_maintained, :boolean
  end
end
