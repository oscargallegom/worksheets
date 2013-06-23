class AddAnimalBmpToFields < ActiveRecord::Migration
  def change
    add_column :fields, :is_livestock_animal_waste_management_system, :boolean
    add_column :fields, :is_livestock_mortality_composting, :boolean
    add_column :fields, :is_livestock_plastic_permeable_lagoon_cover, :boolean
    add_column :fields, :is_livestock_phytase, :boolean
    add_column :fields, :is_livestock_dairy_precision_feeding, :boolean
    add_column :fields, :is_livestock_barnyard_runoff_controls, :boolean
    add_column :fields, :is_livestock_water_control_structure, :boolean
    add_column :fields, :is_livestock_treatment_wetland, :boolean

    add_column :fields, :is_poultry_animal_waste_management_system, :boolean
    add_column :fields, :is_poultry_mortality_composting, :boolean
    add_column :fields, :is_poultry_biofilters, :boolean
    add_column :fields, :is_poultry_vegetated_environmental_buffer, :boolean
    add_column :fields, :is_poultry_phytase, :boolean
    add_column :fields, :is_poultry_heavy_use_pads, :boolean
    add_column :fields, :is_poultry_barnyard_runoff_controls, :boolean
    add_column :fields, :is_poultry_water_control_structure, :boolean
    add_column :fields, :is_poultry_treatment_wetland, :boolean

  end
end

