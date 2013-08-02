class Field < ActiveRecord::Base

  attr_writer :step
  attr_accessor :soil_test_laboratory_id

  belongs_to :farm
  belongs_to :watershed_segment
  belongs_to :irrigation
  belongs_to :field_type
  belongs_to :tmdl
  belongs_to :crop_type
  belongs_to :p_test_method
  belongs_to :vegetation_type, :class_name => "VegetationType", :foreign_key => "vegetation_type_fence_stream_id"
  belongs_to :livestock_input_method

  has_many :strips, :dependent => :destroy, autosave: true

  #has_many :soil_types, :through => :soils
  has_many :soils, :dependent => :destroy, autosave: true

  has_many :bmps, :dependent => :destroy, autosave: true
  has_many :field_livestocks, :dependent => :destroy, autosave: true
  has_many :field_poultry, :dependent => :destroy, autosave: true

  attr_accessible :step
  # , :area, :baseline_load, :coordinates        #  needed???
  attr_accessible :name, :field_type_id, :crop_type_id, :notes
  attr_accessible :acres_from_user, :acres_from_map, :is_acres_from_map, :tile_drainage_depth, :irrigation_id, :efficiency, :fertigation_n, :soil_test_laboratory_id, :soil_p_extractant_id, :p_test_value
  attr_accessible :is_field_adjacent_water
  attr_accessible :is_forest_buffer, :forest_buffer_average_width, :forest_buffer_length, :is_forest_buffer_planned
  attr_accessible :is_grass_buffer, :grass_buffer_average_width, :grass_buffer_length, :is_grass_buffer_planned
  attr_accessible :is_fertilizer_application_setback, :fertilizer_application_setback_average_width, :fertilizer_application_setback_length, :is_fertilizer_application_setback_planned
  attr_accessible :is_wetland, :wetland_area, :wetland_treated_area, :is_wetland_planned

  attr_accessible :is_pasture_adjacent_to_stream, :is_streambank_fencing_in_place, :vegetation_type_fence_stream_id, :fence_length, :distance_fence_stream
  attr_accessible :is_streambank_restoration, :streambank_restoration_length, :is_streambank_restoration_planned

  attr_accessible :planned_management_details

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

  # step 1
  validates_presence_of :name, :field_type_id, :if => 'step?(1)'

  # step 2 and crop or permanent pasture or continuous hay
  # TODO: check field type id
  validates_presence_of :irrigation_id, :soil_test_laboratory_id, :soil_p_extractant_id, :p_test_value, :if => 'step?(2) && (field_type_id==1 || field_type_id==2 || field_type_id==3)'
  validates_presence_of :crop_type_id, :if => 'step?(2) && field_type_id==1'
  validates_inclusion_of :is_acres_from_map, :in => [true, false], :if => 'step?(2) && field_type_id!=4', :message => '^Specify field area'
  validates_numericality_of :tile_drainage_depth, :greater_than_or_equal_to => 0, :allow_blank => true, :if => 'step?(2) && (field_type_id==1 || field_type_id==2 || field_type_id==3)'
  validates_inclusion_of :efficiency, :in => 0..100, :message => "must be between 0 and 100", :if => 'step?(2) && (field_type_id==1 || field_type_id==2 || field_type_id==3) && irrigation_id!=nil && irrigation_id!=0'
  validates_numericality_of :fertigation_n, :allow_blank => true, :greater_than_or_equal_to => 0, :if => 'step?(2) && (field_type_id==1 || field_type_id==2 || field_type_id==3) && (irrigation_id == 500 or irrigation_id == 530)'
  # also for non-managed land
  validates_numericality_of :acres_from_user, :greater_than_or_equal_to => 0, :if => '!is_acres_from_map? && step?(2) && (field_type_id==1 || field_type_id==3 || field_type_id==5)', :message => '^Acres is not a valid number.'

  # step 2 and animal confinement
  validates_presence_of :livestock_input_method_id, :if => 'step?(2) && field_type_id==4'

  # step 4 and permanent pasture
  validates_inclusion_of :is_pasture_adjacent_to_stream, :in => [true, false], :if => 'step?(4) && field_type_id==2'
  validates_numericality_of :fence_length, :if => 'step?(4) && field_type_id==2 && is_pasture_adjacent_to_stream?'
  validates_inclusion_of :is_streambank_fencing_in_place, :in => [true, false], :if => 'step?(4) && field_type_id==2 && is_pasture_adjacent_to_stream?'
  validates_presence_of :vegetation_type_fence_stream_id, :if => 'step?(4) && field_type_id==2 && is_pasture_adjacent_to_stream? && is_streambank_fencing_in_place?'
  validates_numericality_of :distance_fence_stream, :if => 'step?(4) && field_type_id==2 && is_pasture_adjacent_to_stream? && is_streambank_fencing_in_place?'

  # step 4 and crop or continuous hay
  validates_numericality_of :forest_buffer_average_width, :forest_buffer_length, :if => 'step?(4) && (field_type_id==1 || field_type_id==3) && is_forest_buffer?'
  validates_numericality_of :grass_buffer_average_width, :grass_buffer_length, :if => 'step?(4) && (field_type_id==1 || field_type_id==3) && is_grass_buffer?'
  validates_numericality_of :fertilizer_application_setback_average_width, :fertilizer_application_setback_length, :if => 'step?(4) && (field_type_id==1 || field_type_id==3) && is_fertilizer_application_setback?'

  # step 4 for all
  validates_numericality_of :wetland_area, :wetland_treated_area, :if => 'step?(4) && is_wetland?'
  validates_numericality_of :streambank_restoration_length, :if => 'step?(4) && is_streambank_restoration?'

  validates_inclusion_of :is_acres_from_map, :in => [true, false], :allow_blank => true, :if => 'step?(4)'

  # TODO: area of wetland < area of field
  # TODO: area of buffers < area of field (forest, grass and fence)
  # TODO: sum of all buffers < area of field

  # TODO: natural sorting
  default_scope :order => 'name ASC'

  # the user can override the acres retrieved from the map
  def acres
    is_acres_from_map ? acres_from_map : acres_from_user
  end

  #def is_acres_from_user?
  #   !is_acres_from_map?
  #end

  # required fields are based on the current step
  def step?(step)
    @step.to_i==step
  end


  def soil_test_laboratory_id
    if @soil_test_laboratory_id == nil
      SoilPExtractant.where(:id => soil_p_extractant_id).first.soil_test_laboratory_id unless self.soil_p_extractant_id==nil
    else
      @soil_test_laboratory_id # if already entered by end user
    end
  end

  def forest_buffer_area
    self.forest_buffer_average_width * self.forest_buffer_length / 43560.0 unless (self.forest_buffer_average_width.nil? or self.forest_buffer_length.nil?)
  end

  def grass_buffer_area
    self.grass_buffer_average_width * self.grass_buffer_length / 43560.0 unless (self.grass_buffer_average_width.nil? or self.grass_buffer_length.nil?)
  end

  def fertilizer_application_setback_area
    self.fertilizer_application_setback_average_width * self.fertilizer_application_setback_length / 43560.0 unless (self.fertilizer_application_setback_average_width.nil? or self.fertilizer_application_setback_length.nil?)
  end


  def initialized_bmps # this is the key method
    [].tap do |o|
      BmpType.all.each do |bmp_type|
        if c = bmps.find { |c| c.bmp_type_id == bmp_type.id }
          o << c.tap { |c|}
        else
          o << Bmp.new(bmp_type: bmp_type)
        end
      end
    end
  end

  # allow duplication
  amoeba do
    enable
  end

end
