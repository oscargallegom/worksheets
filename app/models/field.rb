class Field < ActiveRecord::Base

  belongs_to :farm
  belongs_to :watershed_segment
  belongs_to :irrigation
  belongs_to :field_type
  belongs_to :crop_type
  belongs_to :p_test_method
  belongs_to :vegetation_type, :class_name => "VegetationType", :foreign_key => "vegetation_type_fence_stream_id"
  belongs_to :livestock_input_method

  has_many :strips

  has_many :soil_types, :through => :soils
  has_many :soils, :dependent => :destroy

  has_many :bmps
  has_many :field_livestocks
  has_many :field_poultry

  attr_accessible :area, :baseline_load, :name, :coordinates
  attr_accessible :name, :field_type_id, :crop_type_id, :notes
  attr_accessible :acres_from_user, :acres_from_map, :is_acres_from_map, :tile_drainage_depth, :irrigation_id, :efficiency, :fertigation_n, :p_test_method_id, :p_test_value
  attr_accessible :is_forest_buffer, :forest_buffer_average_width, :forest_buffer_length, :is_forest_buffer_planned
  attr_accessible :is_grass_buffer, :grass_buffer_average_width, :grass_buffer_length, :is_grass_buffer_planned
  attr_accessible :is_wetland, :wetland_area, :wetland_treated_area, :is_wetland_planned

  attr_accessible :is_pasture_adjacent_to_stream, :is_streambank_fencing_in_place, :vegetation_type_fence_stream_id, :fence_length, :distance_fence_stream
  attr_accessible :is_streambank_restoration, :streambank_restoration_length, :is_streambank_restoration_planned

  attr_accessible :is_livestock_implemented_nutrient_plan, :is_livestock_implemented_soil_water_plan, :is_livestock_properly_sized_maintained
  attr_accessible :is_livestock_animal_waste_management_system, :is_livestock_mortality_composting, :is_livestock_plastic_permeable_lagoon_cover, :is_livestock_phytase, :is_livestock_dairy_precision_feeding, :is_livestock_barnyard_runoff_controls, :is_livestock_water_control_structure, :is_livestock_treatment_wetland
  attr_accessible :is_poultry_animal_waste_management_system, :is_poultry_mortality_composting, :is_poultry_litter_treatment, :is_poultry_biofilters, :is_poultry_vegetated_environmental_buffer, :is_poultry_phytase, :is_poultry_heavy_use_pads, :is_poultry_barnyard_runoff_controls, :is_poultry_water_control_structure, :is_poultry_treatment_wetland

  attr_accessible :soils_attributes
  accepts_nested_attributes_for :soils, :allow_destroy => true

  attr_accessible :strips_attributes
  accepts_nested_attributes_for :strips, :allow_destroy => true

  attr_accessible :livestock_input_method_id

  attr_accessible :field_livestocks_attributes
  accepts_nested_attributes_for :field_livestocks, :allow_destroy => true

  attr_accessible :field_poultry_attributes
  accepts_nested_attributes_for :field_poultry, :allow_destroy => true

  attr_accessible :bmps_attributes
  accepts_nested_attributes_for :bmps, :allow_destroy => true

  # TODO: natural sorting
  default_scope :order => 'name ASC'

  # the user can override the acres retrieved from the map
  def acres
    is_acres_from_map ? acres_from_map : acres_from_user
  end

  def forest_buffer_area
    self.forest_buffer_average_width * self.forest_buffer_length / 43560.0 unless (self.forest_buffer_average_width.nil? or self.forest_buffer_length.nil?)
  end
  def grass_buffer_area
    self.grass_buffer_average_width * self.grass_buffer_length / 43560.0 unless (self.grass_buffer_average_width.nil? or self.grass_buffer_length.nil?)
  end


  def initialized_bmps     # this is the key method
    [].tap do |o|
      BmpType.all.each do |bmp_type|
        if c = bmps.find { |c| c.bmp_type_id == bmp_type.id }
          o << c.tap { |c|  }
        else
          o << Bmp.new(bmp_type: bmp_type)
        end
      end
    end
  end

end
