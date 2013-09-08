class Farm < ActiveRecord::Base

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
      where(' id || \'\' like ? OR name LIKE ? ', "%#{search}%", "%#{search}%")
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


  def percentCompleted

    percentCompleted = 0

    # not field data entered yet
    fields.each do |field|
      if (!field.field_type_id.nil?)
        percentCompleted = 10
      end
    end

    is_one_crop_done = false
    is_all_crop_done = true
    fields.each do |field|
      if (!field.strips.empty? && !field.strips[0].crop_rotations.empty?)
        is_one_crop_done = true
      else
        is_all_crop_done = false
      end
    end


    percentCompleted = 25 if is_one_crop_done
    percentCompleted = 50 if is_all_crop_done

    # TODO: finish %
    #  At least one field completed through “future load summary” 75 percent
    # All fields completed through “future load summary” 100 percent

    return percentCompleted

  end

end
