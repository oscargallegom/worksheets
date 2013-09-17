class AddFutureBmpFieldsToFields < ActiveRecord::Migration
  def change
    remove_column :fields, :is_field_adjacent_water

    add_column :fields, :is_forest_buffer_future, :boolean
    add_column :fields, :forest_buffer_average_width_future, :decimal
    add_column :fields, :forest_buffer_length_future, :decimal
    add_column :fields, :is_forest_buffer_planned_future, :boolean
    add_column :fields, :is_grass_buffer_future, :boolean
    add_column :fields, :grass_buffer_average_width_future, :boolean
    add_column :fields, :grass_buffer_length_future, :boolean
    add_column :fields, :is_grass_buffer_planned_future, :boolean
    add_column :fields, :is_wetland_future, :boolean
    add_column :fields, :wetland_area_future, :decimal
    add_column :fields, :wetland_treated_area_future, :decimal
    add_column :fields, :is_wetland_planned_future, :boolean
    add_column :fields, :is_streambank_restoration_future, :boolean
    add_column :fields, :streambank_restoration_length_future, :decimal
    add_column :fields, :is_streambank_restoration_planned_future, :boolean
    add_column :fields, :is_streambank_fencing_in_place_future, :boolean
    add_column :fields, :distance_fence_stream_future, :decimal
    add_column :fields, :vegetation_type_fence_stream_id_future, :integer
    add_column :fields, :planned_management_details_future, :text
    add_column :fields, :is_fertilizer_application_setback_future, :boolean
    add_column :fields, :fertilizer_application_setback_average_width_future, :decimal
    add_column :fields, :fertilizer_application_setback_length_future, :decimal
    add_column :fields, :is_fertilizer_application_setback_planned_future, :decimal
    add_column :fields, :exclusion_description_future, :text
    add_column :fields, :other_land_use_conversion_acres_future, :decimal
    add_column :fields, :other_land_use_conversion_vegetation_type_id_future, :integer
    add_column :fields, :is_other_land_use_conversion_planned_future, :boolean
  end
end