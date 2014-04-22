class Farm < ActiveRecord::Base
  include BmpCalculations

  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  #belongs_to :site_state, :class_name => 'State', :foreign_key => 'site_state_id'
  #belongs_to :site_county, :class_name => 'State', :foreign_key => 'site_county_id'
  belongs_to :state, :foreign_key => 'site_state_id'
  belongs_to :county, :foreign_key => 'site_county_id'
  belongs_to :generator_type

  has_many :fields, :dependent => :destroy, autosave: true

  has_many :animals, :through => :livestock
  has_many :livestock, :dependent => :destroy, :inverse_of => :farm


  attr_accessible :name, :farm_notes, :tract_number, :generator_type_id, :site_name, :site_street_1, :site_street_2, :site_description, :site_city, :site_zip, :site_state_id, :site_county_id, :coordinates

  attr_accessible :livestock_attributes
  accepts_nested_attributes_for :livestock, :allow_destroy => true

  validates_presence_of :name, :message => '^Farm name can' 't be blank'
  validates_presence_of :generator_type_id, :site_name, :site_state_id, :site_county_id
  validates_format_of :site_zip, :allow_blank => true, :with => %r{\d{5}(-\d{4})?}, :message => "should be using the following format: 12345 or 12345-1234"
  validates_numericality_of :tract_number, :if => :is_maryland?

  # allow duplication
  amoeba do
    enable
    prepend :name => "Copy of "
  end

  def has_animals?
    self.new_record? ? false : !self.livestock.empty?
  end

  # is the selected state Maryland
  def is_maryland?
    self.site_state_id == 21
  end

  # PCL code
  def code
    'PCL-' + ('%06d' % self.id)
  end

  # search by code or name
  def self.search(search)
    if search
      where(' id || \'\' LIKE ? OR name LIKE ? ', "%#{search}%", "%#{search}%")
      # find(:all, :conditions => ['id' LIKE ? OR title LIKE ? OR description LIKE ?', search_condition, search_condition, search_condition])
    else
      scoped
    end
  end

  def acres_from_fields
    field_acres = 0
    fields.each do |field|
      field_acres = field_acres +field.acres
    end
    return(field_acres)
  end

  def animal_headquarters
    nb_fields = 0
    fields.each do |field|
      nb_fields = nb_fields + 1 if field.field_type_id == 4
    end
    nb_fields == 0 ? 'N/A' : nb_fields
  end

  def nonmanaged_land
    nb_fields = 0
    fields.each do |field|
      nb_fields = nb_fields + 1 if field.field_type_id == 5
    end
    nb_fields == 0 ? 'N/A' : nb_fields
  end

  def number_of_fields
    nb_fields = 0
    fields.each do |field|
      nb_fields = nb_fields + 1 if (!field.field_type_id.nil? && field.field_type_id <= 3)
    end
    nb_fields == 0 ? 'N/A' : nb_fields
  end

  def buffered_area
    buffered_area = 0
    fields.each do |field|
      buffered_area = buffered_area + field.forest_buffer_area if (!field.field_type_id.nil? && (field.field_type_id == 1 || field.field_type_id == 3) && field.is_forest_buffer)
      buffered_area = buffered_area + field.grass_buffer_area if (!field.field_type_id.nil? && (field.field_type_id == 1 || field.field_type_id == 3) && field.is_grass_buffer)
    end
    buffered_area == 0 ? 'N/A' : buffered_area
  end

  def wetland_area
    wetland_area = 0
    fields.each do |field|
      wetland_area = wetland_area + field.wetland_area if (!field.field_type_id.nil? && field.field_type_id <= 3 && field.is_wetland)
    end
    wetland_area == 0 ? 'N/A' : wetland_area
  end

  def streambank_fencing_area
    streambank_fencing_area = 0
    fields.each do |field|
      if (field.field_type_id == 2 && field.is_pasture_adjacent_to_stream && field.is_streambank_fencing_in_place?)
        streambank_fencing_area = streambank_fencing_area + field.distance_fence_stream.to_f * field.fence_length.to_f / 43560.0
      end
    end
    streambank_fencing_area == 0 ? 'N/A' : streambank_fencing_area
  end

  def converted_area
    converted_area = 0
    converted_area = converted_area + buffered_area unless buffered_area == 'N/A'
    converted_area = converted_area + wetland_area unless wetland_area == 'N/A'
    converted_area = converted_area + streambank_fencing_area unless streambank_fencing_area == 'N/A'
    converted_area == 0 ? 'N/A' : converted_area
  end

  def credits
    credits = {}
    credits[:total_p] = 0
    credits[:total_n] = 0
    credits[:total_sediment] = 0

    fields.each do |field|

      if (!field.field_type.nil?) && (field.field_type.id == 1 || field.field_type.id == 2 || field.field_type.id == 3)
        @current_totals = {}
        begin
          @current_totals = computeBmpCalculations(field)
        rescue Exception => e
          @current_totals = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0, :new_total_n_future => 0, :new_total_p_future => 0, :new_total_sediment_future => 0}
        ensure
          credits[:total_n] += (@current_totals[:new_total_n] - @current_totals[:new_total_n_future])* field.watershed_segment.n_delivery_factor
          credits[:total_p] += (@current_totals[:new_total_p] - @current_totals[:new_total_p_future])* field.watershed_segment.p_delivery_factor
          credits[:total_sediment] += (@current_totals[:new_total_sediment] - @current_totals[:new_total_sediment_future])* field.watershed_segment.sediment_delivery_factor
        end
     end

      if (!field.field_type.nil?) && (field.field_type_id == 4) # perform calculations for animal confinement
        @current_totals = {}
        @future_totals = {}
        begin
          @current_totals = computeLivestockBmpCalculations(field)
          @future_totals = computeLivestockBmpCalculationsFuture(field)
        rescue Exception => e
          @current_totals = {:current_load_nitrogen => 0, :current_load_phosphorus => 0, :current_load_sediment => 0}
          @future_totals = {:current_load_nitrogen => 0, :current_load_phosphorus => 0, :current_load_sediment => 0}
        ensure
        credits[:total_n] += (@current_totals[:current_load_nitrogen]-@future_totals[:current_load_nitrogen])* field.watershed_segment.n_delivery_factor
        credits[:total_p] += (@current_totals[:current_load_phosphorus]-@future_totals[:current_load_phosphorus])* field.watershed_segment.p_delivery_factor
        credits[:total_sediment] += (@current_totals[:current_load_sediment]-@future_totals[:current_load_sediment])* field.watershed_segment.sediment_delivery_factor
        end
      end
    end

    return credits
  end

  # def does_farm_meet_n_baseline
  #   if self.site_state_id == 47
  #     if is_farm_meets_baseline(self) == true
  #       return 'Yes'
  #     else
  #       return 'No'
  #     end
  #   else
  #     if is_farm_meets_baseline(self) == true
  #       if @baseline_n_load_fields
  #         return 'Yes'
  #       else 
  #         return 'HI'
  #       end
  #     else
  #       return 'No'
  #     end
  #   end
  # end


  def percentCompleted

    percentCompleted = 0

    # not field data entered yet
    fields.each do |field|
      if (!field.field_type_id.nil?)
        percentCompleted = 10
      end
    end

    #nb_fields_completed = 0
    #fields.each do |field|
    #  if (!field.strips.empty? && !field.strips[0].crop_rotations.empty?)
    #    nb_fields_completed = nb_fields_completed + 1
    #  end
    #end

    percentFieldCompleted = 0
    if fields.size > 0
      fields.each do |field|
        percentFieldCompleted += field.percentCompleted
      end
      percentFieldCompleted = percentFieldCompleted / fields.size
    end

    #percentFieldCompleted = 0
    #if fields.size > 0
    #  percentFieldCompleted = [90, (nb_fields_completed / fields.size * 100).round].min
    #end

    percentCompleted = [percentCompleted, percentFieldCompleted].max

    # TODO: finish %
    #  At least one field completed through “future load summary” 75 percent
    # All fields completed through “future load summary” 100 percent

    return percentCompleted

  end

end