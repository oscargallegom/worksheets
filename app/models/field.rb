class Field < ActiveRecord::Base
  #TODO: just a test for now
  include Ntt
  include BmpCalculations
  include BaselineCheck


  before_save :update_ntt_xml_fields

  attr_writer :step
  attr_accessor :soil_test_laboratory_id, :modified_p_test_value
  attr_writer :ntt_call_status

  attr_writer :bmp_calculations

  serialize :totals

  belongs_to :farm
  belongs_to :watershed_segment
  belongs_to :irrigation
  belongs_to :field_type
  belongs_to :tmdl
  belongs_to :crop_type
  belongs_to :p_test_method
  belongs_to :vegetation_type, :class_name => "VegetationType", :foreign_key => "vegetation_type_fence_stream_id"
  belongs_to :livestock_input_method
  belongs_to :soil_texture

  has_many :strips, :dependent => :destroy, autosave: true

  #has_many :soil_types, :through => :soils
  has_many :soils, :dependent => :destroy, autosave: true

  has_many :bmps, :dependent => :destroy, autosave: true
  has_many :future_bmps, :dependent => :destroy, autosave: true
  has_many :field_livestocks, :dependent => :destroy, autosave: true
  has_many :field_poultry, :dependent => :destroy, autosave: true

  attr_accessible :step, :segment_id, :hel_soils, :current_total_n, :current_sediment_organic_n, :current_soluble_n, :tile_drained_n, :current_total_p, :current_sediment_organic_p, :current_soluble_p, :tile_drained_p, :future_total_n, :future_sediment_organic_n, :future_soluble_n, :future_tile_drained_n, :future_total_p, :future_sediment_organic_p, :future_soluble_p, :future_tile_drained_p , :current_flow, :future_flow, :current_sediment, :future_sediment, :current_carbon, :future_carbon
  # , :area, :baseline_load, :coordinates        #  needed???
  attr_accessible :name, :field_type_id, :crop_type_id, :notes, :farm_id
  attr_accessible :acres_from_user, :acres_from_map, :is_acres_from_map, :tile_drainage_depth, :irrigation_id, :efficiency, :fertigation_n, :soil_test_laboratory_id, :soil_p_extractant_id, :p_test_value
  attr_accessible :soil_texture_id, :slope

  attr_accessible :is_forest_buffer, :forest_buffer_average_width, :forest_buffer_length, :is_forest_buffer_planned
  attr_accessible :is_forest_buffer_future, :forest_buffer_average_width_future, :forest_buffer_length_future, :is_forest_buffer_planned_future

  attr_accessible :is_grass_buffer, :grass_buffer_average_width, :grass_buffer_length, :is_grass_buffer_planned
  attr_accessible :is_grass_buffer_future, :grass_buffer_average_width_future, :grass_buffer_length_future, :is_grass_buffer_planned_future

  attr_accessible :is_fertilizer_application_setback, :fertilizer_application_setback_average_width, :fertilizer_application_setback_length, :is_fertilizer_application_setback_planned
  attr_accessible :is_fertilizer_application_setback_future, :fertilizer_application_setback_average_width_future, :fertilizer_application_setback_length_future, :is_fertilizer_application_setback_planned_future

  attr_accessible :is_wetland, :wetland_area, :wetland_treated_area, :is_wetland_planned
  attr_accessible :is_wetland_future, :wetland_area_future, :wetland_treated_area_future, :is_wetland_planned_future

  attr_accessible :other_land_use_conversion_acres, :other_land_use_conversion_vegetation_type_id, :is_other_land_use_conversion_planned
  attr_accessible :other_land_use_conversion_acres_future, :other_land_use_conversion_vegetation_type_id_future, :is_other_land_use_conversion_planned_future


  attr_accessible :is_pasture_adjacent_to_stream

  attr_accessible :is_streambank_fencing_in_place, :fence_length, :vegetation_type_fence_stream_id, :distance_fence_stream, :exclusion_description
  attr_accessible :is_streambank_fencing_in_place_future, :fence_length_future, :vegetation_type_fence_stream_id_future, :distance_fence_stream_future, :exclusion_description_future

  attr_accessible :is_streambank_restoration, :streambank_restoration_length, :is_streambank_restoration_planned
  attr_accessible :is_streambank_restoration_future, :streambank_restoration_length_future, :is_streambank_restoration_planned_future


  attr_accessible :planned_management_details
  attr_accessible :planned_management_details_future

  attr_accessible :is_livestock_implemented_nutrient_plan, :is_livestock_implemented_soil_water_plan, :is_livestock_properly_sized_maintained
  attr_accessible :is_livestock_animal_waste_management_system, :is_livestock_mortality_composting, :is_livestock_plastic_permeable_lagoon_cover, :is_livestock_phytase, :is_livestock_dairy_precision_feeding, :is_livestock_barnyard_runoff_controls, :is_livestock_water_control_structure, :is_livestock_treatment_wetland
  attr_accessible :is_poultry_animal_waste_management_system, :is_poultry_mortality_composting, :is_poultry_litter_treatment, :is_poultry_biofilters, :is_poultry_vegetated_environmental_buffer, :is_poultry_phytase, :is_poultry_heavy_use_pads, :is_poultry_barnyard_runoff_controls, :is_poultry_water_control_structure, :is_poultry_treatment_wetland

  # future
  attr_accessible :is_livestock_animal_waste_management_system_future, :is_livestock_mortality_composting_future, :is_livestock_plastic_permeable_lagoon_cover_future, :is_livestock_phytase_future, :is_livestock_dairy_precision_feeding_future, :is_livestock_barnyard_runoff_controls_future, :is_livestock_water_control_structure_future, :is_livestock_treatment_wetland_future
  attr_accessible :is_poultry_animal_waste_management_system_future, :is_poultry_mortality_composting_future, :is_poultry_litter_treatment_future, :is_poultry_biofilters_future, :is_poultry_vegetated_environmental_buffer_future, :is_poultry_phytase_future, :is_poultry_heavy_use_pads_future, :is_poultry_barnyard_runoff_controls_future, :is_poultry_water_control_structure_future, :is_poultry_treatment_wetland_future


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

  attr_accessible :future_bmps_attributes
  accepts_nested_attributes_for :future_bmps, :allow_destroy => true

  # step 1
  validates_presence_of :name, :field_type_id, :if => 'step?(1)'
  validates_inclusion_of :is_pasture_adjacent_to_stream, :in => [true, false], :if => 'step?(1)'

  # step 2 and crop or permanent pasture or continuous hay
  # TODO: check field type id
  validates_presence_of :irrigation_id, :soil_test_laboratory_id, :soil_p_extractant_id, :p_test_value, :if => 'step?(2) && (field_type_id==1 || field_type_id==2 || field_type_id==3)'
  validates_presence_of :crop_type_id, :if => 'step?(2) && field_type_id==1'
  validates_inclusion_of :is_acres_from_map, :in => [true, false], :if => 'step?(2)', :message => '^Specify field area'
  validates_numericality_of :tile_drainage_depth, :greater_than_or_equal_to => 0, :allow_blank => true, :if => 'step?(2) && (field_type_id==1 || field_type_id==2 || field_type_id==3)'
  validates_inclusion_of :efficiency, :in => 0..100, :message => "must be between 0 and 100", :if => 'step?(2) && (field_type_id==1 || field_type_id==2 || field_type_id==3) && irrigation_id!=nil && irrigation_id!=0 && irrigation_id!=999'
  validates_numericality_of :fertigation_n, :allow_blank => true, :greater_than_or_equal_to => 0, :if => 'step?(2) && (field_type_id==1 || field_type_id==2 || field_type_id==3) && (irrigation_id == 500 or irrigation_id == 530)'
  # also for non-managed land
  validates_numericality_of :acres_from_user, :greater_than_or_equal_to => 0, :if => '!is_acres_from_map? && step?(2)', :message => '^Acres is not a valid number.'

  # only if no soil data returned
  validates_presence_of :soil_texture_id, :if => 'step?(2) && self.soils.empty? && (field_type_id==1 || field_type_id==2 || field_type_id==3)'
  validates_inclusion_of :slope, :in => 0..100, :message => 'must be between 0 and 100', :if => 'step?(2) && self.soils.empty? && (field_type_id==1 || field_type_id==2 || field_type_id==3)'

  # step 2 and animal confinement
  validates_presence_of :livestock_input_method_id, :if => 'step?(2) && field_type_id==4'

  # step 4 and permanent pasture
  validates_inclusion_of :is_streambank_fencing_in_place, :in => [true, false], :if => 'step?(4) && field_type_id==2 && is_pasture_adjacent_to_stream?'
  validates_presence_of :vegetation_type_fence_stream_id, :if => 'step?(4) && field_type_id==2 && is_pasture_adjacent_to_stream? && is_streambank_fencing_in_place?'
  validates_numericality_of :distance_fence_stream, :if => 'step?(4) && field_type_id==2 && is_pasture_adjacent_to_stream? && is_streambank_fencing_in_place?'
  validates_numericality_of :fence_length, :if => 'step?(4) && field_type_id==2 && is_pasture_adjacent_to_stream?'

  # step 4 and crop or continuous hay
  validates_numericality_of :forest_buffer_average_width, :forest_buffer_length, :if => 'step?(4) && (field_type_id==1 || field_type_id==3) && is_forest_buffer?'
  validates_numericality_of :grass_buffer_average_width, :grass_buffer_length, :if => 'step?(4) && (field_type_id==1 || field_type_id==3) && is_grass_buffer?'
  validates_numericality_of :fertilizer_application_setback_average_width, :fertilizer_application_setback_length, :if => 'step?(4) && (field_type_id==1 || field_type_id==3) && is_fertilizer_application_setback?'

  # step 4 for all
  validates_numericality_of :wetland_area, :wetland_treated_area, :greater_than_or_equal_to => 0, :if => 'step?(4) && is_wetland?'
  validates_numericality_of :streambank_restoration_length, :greater_than_or_equal_to => 0, :if => 'step?(4) && is_streambank_restoration?'
  validates_numericality_of :other_land_use_conversion_acres, :greater_than_or_equal_to => 0, :allow_blank => true, :if => 'step?(4)'

  #validates_inclusion_of :is_acres_from_map, :in => [true, false], :allow_blank => true, :if => 'step?(4)'

  # step 7 and permanent pasture
  validates_inclusion_of :is_streambank_fencing_in_place_future, :in => [true, false], :if => 'step?(7) && field_type_id==2 && is_pasture_adjacent_to_stream?'
  validates_presence_of :vegetation_type_fence_stream_id_future, :if => 'step?(7) && field_type_id==2 && is_pasture_adjacent_to_stream? && is_streambank_fencing_in_place_future?'
  validates_numericality_of :distance_fence_stream_future, :if => 'step?(7) && field_type_id==2 && is_pasture_adjacent_to_stream? && is_streambank_fencing_in_place_future?'
  validates_numericality_of :fence_length_future, :if => 'step?(7) && field_type_id==2 && is_pasture_adjacent_to_stream?'

  # step 7 and crop or continuous hay
  validates_numericality_of :forest_buffer_average_width_future, :forest_buffer_length_future, :if => 'step?(7) && (field_type_id==1 || field_type_id==3) && is_forest_buffer_future?'
  validates_numericality_of :grass_buffer_average_width_future, :grass_buffer_length_future, :if => 'step?(7) && (field_type_id==1 || field_type_id==3) && is_grass_buffer_future?'
  validates_numericality_of :fertilizer_application_setback_average_width_future, :fertilizer_application_setback_length_future, :if => 'step?(7) && (field_type_id==1 || field_type_id==3) && is_fertilizer_application_setback_future?'

  # step 7 for all
  validates_numericality_of :wetland_area_future, :wetland_treated_area_future, :greater_than_or_equal_to => 0, :if => 'step?(7) && is_wetland_future?'
  validates_numericality_of :streambank_restoration_length_future, :greater_than_or_equal_to => 0, :if => 'step?(7) && is_streambank_restoration_future?'
  validates_numericality_of :other_land_use_conversion_acres_future, :greater_than_or_equal_to => 0, :allow_blank => true, :if => 'step?(7)'

  # TODO: area of wetland < area of field
  # TODO: area of buffers < area of field (forest, grass and fence)
  # TODO: sum of all buffers < area of field

  # TODO: natural sorting
  default_scope :order => 'name ASC'

  validate :strip_check
#find a better way to do this....
   def strip_check
    unless self.field_type_id == 4
    if step?(4)
       @strips = self.strips
       @strips.each do |strip|
        unless strip.is_future == true
            if strip.crop_rotations.empty?
              errors.add(:strip, "must have at least one crop rotation. Please return to the crop management tab and either delete the empty strip or add rotations.")
            end
          end
        end
      end
    end
    end

    def stream
      if self.is_pasture_adjacent_to_stream?
        return "Yes"
      else
        return "No"
      end
    end

  def does_field_meet_baseline
    @messages = Hash.new
    @messages[:meets_baseline] = true
    @messages[:errors] = Array.new
    @checked_bmp = false
    @checked_setback = false
    @checked_hel = false
    if self.field_type_id
      get_field_type
    end
    return @messages
  end 

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

  def bmp_calculations

    if @bmp_calculations.nil?
      begin
        if (field_type_id <= 3)
          @bmp_calculations = computeBmpCalculations(self)
        elsif (field_type_id == 4) # animal confinment
          @bmp_calculations_animal_confinment = computeLivestockBmpCalculations(self)
          @bmp_calculations_animal_confinment_future = computeLivestockBmpCalculationsFuture(self)
          @bmp_calculations = {:new_total_n => @bmp_calculations_animal_confinment[:current_load_nitrogen], :new_total_p => @bmp_calculations_animal_confinment[:current_load_phosphorus], :new_total_sediment => @bmp_calculations_animal_confinment[:current_load_sediment], :new_total_n_future => @bmp_calculations_animal_confinment_future[:current_load_nitrogen], :new_total_p_future => @bmp_calculations_animal_confinment_future[:current_load_phosphorus], :new_total_sediment_future => @bmp_calculations_animal_confinment_future[:current_load_sediment], :error_message => ''}
        else
          @bmp_calculations = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0, :new_total_n_future => 0, :new_total_p_future => 0, :new_total_sediment_future => 0, :error_message => ''}
        end
      rescue Exception => e
        @bmp_calculations = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0, :new_total_n_future => 0, :new_total_p_future => 0, :new_total_sediment_future => 0, :error_message => 'Error: ' + e.message}
      end
    else
      @bmp_calculations
    end

  end

  def field_converted_area
    conversion = 0
    if is_forest_buffer?
      conversion = conversion + forest_buffer_area
    end
    if is_grass_buffer?
      conversion = conversion + grass_buffer_area
    end 
    if is_wetland?
      conversion = conversion + wetland_area
    end
    if is_streambank_fencing_in_place?
      conversion = conversion + ((distance_fence_stream.to_f * fence_length.to_f) / 43560.0)
    end
    if is_fertilizer_application_setback?
      conversion = conversion + ((fertilizer_application_setback_average_width.to_f * fertilizer_application_setback_length.to_f) / 43560.0)
    end
    if other_land_use_conversion_acres
      unless other_land_use_conversion_acres == 0
      conversion = conversion + other_land_use_conversion_acres
    end
    end
    return conversion
  end

  def field_converted_area_future
    conversion = 0
    if is_forest_buffer_future?
      conversion = conversion + forest_buffer_area_future
    end
    if is_grass_buffer_future?
      conversion = conversion + grass_buffer_area_future
    end
    if is_wetland_future?
      conversion = conversion + wetland_area_future
    end
    if is_streambank_fencing_in_place_future?
      conversion = conversion + ((distance_fence_stream_future.to_f * fence_length_future.to_f) / 43560.0)
    end
    if is_fertilizer_application_setback_future?
      conversion = conversion + ((fertilizer_application_setback_average_width_future.to_f * fertilizer_application_setback_length_future.to_f) / 43560.0)
    end
    if other_land_use_conversion_acres_future
      unless other_land_use_conversion_acres_future == 0
      conversion = conversion + other_land_use_conversion_acres_future
    end
    end
    return conversion
  end

def has_conversion
  conversion = false
  if is_forest_buffer?
    conversion = true
  elsif is_grass_buffer?
    conversion = true
  elsif is_wetland?
    conversion = true
  elsif is_streambank_fencing_in_place?
    conversion = true
  elsif is_fertilizer_application_setback?
    conversion = true
  elsif other_land_use_conversion_acres
    unless other_land_use_conversion_acres == 0
    conversion = true
  end
  end
  return conversion
  logger.debug "%%%%%%%%%%%%%%%%%%%%% conversion: #{conversion}"
end
def has_conversion_future
  conversion = false
  if is_forest_buffer_future?
    conversion = true
  elsif is_grass_buffer_future?
    conversion = true
  elsif is_wetland_future?
    conversion = true
  elsif is_streambank_fencing_in_place_future?
    conversion = true
  elsif is_fertilizer_application_setback_future?
    conversion = true
  elsif other_land_use_conversion_acres_future
    unless other_land_use_conversion_acres_future == 0
    conversion = true
  end
  end
  return conversion
end

def has_cover_crop
  cover_crop = false
      self.strips.each do |strip|
        if !strip.is_future?
        strip.crop_rotations.each do |crop|
            if crop.is_cover_crop
              cover_crop = true
            end
          end
        end
      end
      return cover_crop
  end

  def has_cover_crop_future
  cover_crop = false
      self.strips.each do |strip|
        if strip.is_future?
        strip.crop_rotations.each do |crop|
            if crop.is_cover_crop
              cover_crop = true
            end
          end
        end
      end
      return cover_crop
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

  # future BMP tab
  def forest_buffer_area_future
    self.forest_buffer_average_width_future * self.forest_buffer_length_future / 43560.0 unless (self.forest_buffer_average_width_future.nil? or self.forest_buffer_length_future.nil?)
  end

  def grass_buffer_area_future
    self.grass_buffer_average_width_future * self.grass_buffer_length_future / 43560.0 unless (self.grass_buffer_average_width_future.nil? or self.grass_buffer_length_future.nil?)
  end

  def fertilizer_application_setback_area_future
    self.fertilizer_application_setback_average_width_future * self.fertilizer_application_setback_length_future / 43560.0 unless (self.fertilizer_application_setback_average_width_future.nil? or self.fertilizer_application_setback_length_future.nil?)
  end

  def n_baseline
    n_baseline = nil
    if self.tmdl.nil?
      n_baseline = self.watershed_segment[:n_crop_baseline].to_f if field_type_id == 1 && !self.watershed_segment.nil?
      n_baseline = self.watershed_segment[:n_pasture_baseline].to_f if field_type_id == 2 && !self.watershed_segment.nil?
      n_baseline = self.watershed_segment[:n_hay_baseline].to_f if field_type_id == 3 && !self.watershed_segment.nil?
    else
      n_baseline = self.tmdl[:total_n]
    end
    return n_baseline
  end

  def p_baseline
    p_baseline = nil
    if self.tmdl.nil?
      p_baseline = self.watershed_segment[:p_crop_baseline].to_f if field_type_id == 1 && !self.watershed_segment.nil?
      p_baseline = self.watershed_segment[:p_pasture_baseline].to_f if field_type_id == 2 && !self.watershed_segment.nil?
      p_baseline = self.watershed_segment[:p_hay_baseline].to_f if field_type_id == 3 && !self.watershed_segment.nil?
    else
      p_baseline = self.tmdl[:total_p]
    end
    return p_baseline
  end

  def sediment_baseline
    sediment_baseline = nil
    sediment_baseline = self.watershed_segment[:sediment_crop_baseline].to_f / 2000.0 if field_type_id == 1 && !self.watershed_segment.nil?
    sediment_baseline = self.watershed_segment[:sediment_pasture_baseline].to_f / 2000.0 if field_type_id == 2 && !self.watershed_segment.nil?
    sediment_baseline = self.watershed_segment[:sediment_hay_baseline].to_f / 2000.0 if field_type_id == 3 && !self.watershed_segment.nil?
    return sediment_baseline
  end

  def modified_p_test_value
    modified_p_test_value = 0
    soil_p_extractant = SoilPExtractant.where(:id => self.soil_p_extractant_id).first
    if (!soil_p_extractant.nil?)
      if (soil_p_extractant.formula_code == 1)
        modified_p_test_value = (self.p_test_value + 54.145) / 4.6438
      elsif (soil_p_extractant.formula_code == 2)
        modified_p_test_value = (((((self.p_test_value + soil_p_extractant.b_value.to_f) / soil_p_extractant.m_value.to_f) + soil_p_extractant.g_value.to_f) / soil_p_extractant.h_value.to_f) + 54.145) / 4.6438
      else
        modified_p_test_value = (((self.p_test_value + soil_p_extractant.b_value.to_f) / soil_p_extractant.m_value.to_f) + 54.145) / 4.6438
      end
    end

    return modified_p_test_value
  end


  #def initialized_bmps # this is the key method
  #  [].tap do |o|
  #    BmpType.all.each do |bmp_type|
  #      if c = bmps.find { |c| c.bmp_type_id == bmp_type.id }
  #        o << c.tap { |c|}
  #      else
  #        o << Bmp.new(bmp_type: bmp_type)
  #      end
  #    end
  #  end
  #end

  def crops
        @current_totals = computeBmpCalculations(self)
        @ntt_results = @current_totals[:ntt_results]
        crops = @ntt_results[:crops]
        return crops
  end

  def current_n_load
        @current_totals = computeBmpCalculations(self)
        @ntt_results = @current_totals[:ntt_results]
        n_load = @current_totals[:new_total_n]
        return n_load
  end

    def current_p_load
        @current_totals = computeBmpCalculations(self)
        @ntt_results = @current_totals[:ntt_results]
        p_load = @current_totals[:new_total_p]
        return p_load
  end

  def current_s_load
        @current_totals = computeBmpCalculations(self)
        @ntt_results = @current_totals[:ntt_results]
        s_load = @current_totals[:new_total_sediment]
        return s_load
  end

    def future_n_load
        @current_totals = computeBmpCalculations(self)
        @ntt_results = @current_totals[:ntt_results]
        n_load = @current_totals[:new_total_n_future]
        return n_load
  end

      def future_p_load
        @current_totals = computeBmpCalculations(self)
        @ntt_results = @current_totals[:ntt_results]
        p_load = @current_totals[:new_total_p_future]
        return p_load
  end

  def future_s_load
        @current_totals = computeBmpCalculations(self)
        @ntt_results = @current_totals[:ntt_results]
        s_load = @current_totals[:new_total_sediment_future]
        return s_load
  end

    def animal_current_n_load
        @current_totals = computeLivestockBmpCalculations(self)
        @ntt_results = @current_totals[:ntt_results]
        n_load = @current_totals[:current_load_nitrogen]
        return n_load
  end

      def animal_future_n_load
        @future_totals = computeLivestockBmpCalculationsFuture(self)
        @ntt_results = @future_totals[:ntt_results]
        n_load = @future_totals[:current_load_nitrogen]
        return n_load
  end

      def animal_current_p_load
        @current_totals = computeLivestockBmpCalculations(self)
        @ntt_results = @current_totals[:ntt_results]
        p_load = @current_totals[:current_load_phosphorus]
        return p_load
  end

      def animal_future_p_load
        @future_totals = computeLivestockBmpCalculationsFuture(self)
        @ntt_results = @future_totals[:ntt_results]
        p_load = @future_totals[:current_load_phosphorus]
        return p_load
  end

        def animal_current_s_load
        @current_totals = computeLivestockBmpCalculations(self)
        @ntt_results = @current_totals[:ntt_results]
        s_load = @current_totals[:current_load_sediment]
        return s_load
  end

      def animal_future_s_load
        @future_totals = computeLivestockBmpCalculationsFuture(self)
        @ntt_results = @future_totals[:ntt_results]
        s_load = @future_totals[:current_load_sediment]
        return s_load
  end


  def percentCompleted

    percentCompleted = 0

    # not field data entered yet
    percentCompleted = 10 if !self.field_type.nil?

    self.strips.each do |strip|
      if (!strip.is_future && !strip.crop_rotations.empty?)
        percentCompleted = 50
      end
      if (strip.is_future && !strip.crop_rotations.empty?)
        percentCompleted = 100
        break
      end
    end

    # if animal confinment
    if (!self.field_type.nil?) && (self.field_type_id == 4) && (!self.field_livestocks.nil? || !self.field_poultry.nil?)
      percentCompleted = 100
    end

    # if managed land
    if (!self.field_type.nil?) && (self.field_type_id == 5)
      percentCompleted = 100
    end

    #is_one_crop_done = false
    #is_all_crop_done = true
    #fields.each do |field|
    #  if (!field.strips.empty? && !field.strips[0].crop_rotations.empty?)
    #    is_one_crop_done = true
    #  else
    #    is_all_crop_done = false
    #  end
    #end


    #percentCompleted = 25 if is_one_crop_done
    #percentCompleted = 50 if is_all_crop_done

    # TODO: finish %
    #  At least one field completed through “future load summary” 75 percent
    # All fields completed through “future load summary” 100 percent

    return percentCompleted

  end

  
  def maryland?
    self.farm.site_state_id == 21
  end

  def virginia?
    self.farm.site_state_id == 47
  end

  # allow duplication
  amoeba do
    enable
  end

  private
  def update_ntt_xml_fields

    ENV['debug'] ||= ''
    self[:ntt_call_status] = ''

    is_changed = (self.ntt_xml_current.nil? || self.ntt_xml_future.nil?)

    # check if the soil data has changed
    if (!is_changed)
      self.soils.each do |soil|
        if (soil.changed? || soil.marked_for_destruction?)
          is_changed = true
          self.ntt_xml_current = nil
          self.ntt_xml_future = nil
          puts 'Soils changed'
          ENV['debug'] += 'Soils changed<br/>'
          break
        end
      end
    end

    # check if strips changed
    if (!is_changed)
      is_strip_changed = false
      self.strips.each do |strip|
        if (strip.changed? || strip.marked_for_destruction?)
          is_changed = true
          if strip.is_future
            self.ntt_xml_future = nil
          else
            self.ntt_xml_current = nil
          end
          puts 'Strip changed'
          ENV['debug'] += 'Strip changed<br/>'
          break
        end
      end
    end


    # check if BMPs have changed
    #if (!is_changed)
    #  self.bmps.each do |bmp|
    #    if (bmp.changed? || bmp.marked_for_destruction?)
    #      is_changed = true
    #      self.ntt_xml_current = nil
    #      puts 'BMP changed'
    #      ENV['debug'] += 'BMP changed changed<br/>'
    #      break
    #    end
    #  end
    #end

    # check if future BMPs have changed
    #if (!is_changed)
    #  self.future_bmps.each do |future_bmp|
    #    if (future_bmp.changed? || future_bmp.marked_for_destruction?)
    #      is_changed = true
    #      self.ntt_xml_future = nil
    #      puts 'Future BMP changed'
    #      ENV['debug'] += 'Future BMP changed<br/>'
    #      break
    #    end
    #  end
    #end

    # note that there is a bug if the value is 0.0 hence the extra check between old and new value
    #  see 'https://github.com/rails/rails/pull/9042' for details
    if (self.acres_from_user_changed? ||
        self.acres_from_map_changed? ||
        self.is_acres_from_map_changed? ||
        (self.tile_drainage_depth_changed? && self.tile_drainage_depth_change[0]!=self.tile_drainage_depth_change[1]) ||
        self.irrigation_id_changed? ||
        (self.fertigation_n_changed? && self.fertigation_n_change[0]!=self.fertigation_n_change[1]) ||
        (self.p_test_value_changed? && self.p_test_value_change[0]!=self.p_test_value_change[1]) ||
        (self.efficiency_changed? && self.efficiency_change[0]!=self.efficiency_change[1]) ||
        self.crop_type_id_changed? ||
        self.soil_p_extractant_id_changed? ||
        self.soil_texture_id_changed? ||
        (self.slope_changed? && self.slope_change[0]!=self.slope_change[1]))
      is_changed = true
      self.ntt_xml_current = nil
      self.ntt_xml_future = nil
      ENV['debug'] += 'Field changed (' + self.changed.to_s + ")<br/>"
    end

    if is_changed

      # each strip should have at least one crop rotation
      is_current_data_valid= true
      is_future_data_valid =true
      self.strips.each do |strip|
        if (strip.crop_rotations.empty? && !strip.marked_for_destruction?)
          if (strip.is_future?)
            is_future_data_valid = false
          else
            is_current_data_valid =false
          end
        end
      end

      # TODO: test when to call NTT
      if (is_current_data_valid && self.ntt_xml_current.nil?)

      #   success, content = callNtt(self, false)

      #   if success
      #     @ntt_results = Hash.from_xml(content.xpath('//Results').to_s)['Results']
      #     if (@ntt_results['ErrorCode'] != '0')
      #       self.ntt_xml_current = nil
      #       ENV['debug'] += 'Error retrieving current<br/>'
      #       self[:ntt_call_status] += 'Could not retrieve NTT data.'
      #       #raise 'Could not retrieve NTT data.'
      #     else
      #       self.ntt_xml_current = content.to_s
      #     end
      #   else
      #     self.ntt_xml_current = nil
      #     ENV['debug'] += 'Error retriebing current<br/>'
      #     self[:ntt_call_status] += 'Could not retrieve NTT data:' + content.to_s
      #     #raise 'Could not retrieve NTT data: ' + content.to_s
      #   end

      end

      if (is_future_data_valid && self.ntt_xml_future.nil?)

        # now  for the future
        # success, content = callNtt(self, true)

        # if (success)
        #   @ntt_results = Hash.from_xml(content.xpath('//Results').to_s)['Results']
        #   if (@ntt_results['ErrorCode'] != '0')
        #     self.ntt_xml_future = nil
        #     #raise 'Could not retrieve NTT data for future scenario.'
        #     self[:ntt_call_status] += 'Could not retrieve NTT data for future scenario.'
        #     ENV['debug'] += 'Error retrieving future<br/>'
        #   else
        #     self.ntt_xml_future = content.to_s
        #   end
        # else
        #   self.ntt_xml_future = nil
        #   ENV['debug'] += '<br/>Error retrieving future<br/>'
        #   self[:ntt_call_status] += 'Could not retrieve NTT data for future scenario: ' + content.to_s
        #   #raise 'Could not retrieve NTT data for future scenario: ' + content.to_s
        # end
      end
    end
  end



end

