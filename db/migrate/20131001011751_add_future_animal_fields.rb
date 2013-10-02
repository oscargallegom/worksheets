class AddFutureAnimalFields < ActiveRecord::Migration
  def change
      add_column :fields, :is_livestock_animal_waste_management_system_future, :boolean
      add_column :fields, :is_livestock_mortality_composting_future, :boolean
      add_column :fields, :is_livestock_plastic_permeable_lagoon_cover_future, :boolean
      add_column :fields, :is_livestock_phytase_future, :boolean
      add_column :fields, :is_livestock_dairy_precision_feeding_future, :boolean
      add_column :fields, :is_livestock_barnyard_runoff_controls_future, :boolean
      add_column :fields, :is_livestock_water_control_structure_future, :boolean
      add_column :fields, :is_livestock_treatment_wetland_future, :boolean
      add_column :fields, :is_poultry_animal_waste_management_system_future, :boolean
      add_column :fields, :is_poultry_mortality_composting_future, :boolean
      add_column :fields, :is_poultry_biofilters_future, :boolean
      add_column :fields, :is_poultry_vegetated_environmental_buffer_future, :boolean
      add_column :fields, :is_poultry_phytase_future, :boolean
      add_column :fields, :is_poultry_heavy_use_pads_future, :boolean
      add_column :fields, :is_poultry_barnyard_runoff_controls_future, :boolean
      add_column :fields, :is_poultry_water_control_structure_future, :boolean
      add_column :fields, :is_poultry_treatment_wetland_future, :boolean
      add_column :fields, :is_poultry_litter_treatment_future, :boolean
  end
end
