class CropRotation < ActiveRecord::Base

  #  if any  change then ntt needs to be called
  before_save :reset_ntt_xml
  before_destroy :reset_ntt_xml

  attr_accessor :crop_category_id

  belongs_to :crop #, :inverse_of => :crop_rotations
  belongs_to :strip #, :inverse_of => :crop_rotations

  belongs_to :cover_crop, class_name: 'Crop'

  has_many :grazing_livestocks, :dependent => :destroy, autosave: true
  has_many :tillage_operations, :dependent => :destroy, autosave: true
  has_many :manure_fertilizer_applications, :dependent => :destroy, autosave: true
  has_many :commercial_fertilizer_applications, :dependent => :destroy, autosave: true
  has_many :end_of_seasons, :dependent => :destroy, autosave: true

  attr_accessible :strip_id, :crop_category_id, :crop_id, :plant_date_year, :plant_date_month, :plant_date_day, :planting_method_id, :seeding_rate
  attr_accessible :is_cover_crop, :cover_crop_id, :cover_crop_plant_date_year, :cover_crop_plant_date_month, :cover_crop_plant_date_day, :cover_crop_planting_method_id

  attr_accessible :grazing_livestocks_attributes
  accepts_nested_attributes_for :grazing_livestocks, :allow_destroy => true

  attr_accessible :tillage_operations_attributes
  accepts_nested_attributes_for :tillage_operations, :allow_destroy => true

  attr_accessible :manure_fertilizer_applications_attributes
  accepts_nested_attributes_for :manure_fertilizer_applications, :allow_destroy => true

  attr_accessible :commercial_fertilizer_applications_attributes
  accepts_nested_attributes_for :commercial_fertilizer_applications, :allow_destroy => true

  attr_accessible :end_of_seasons_attributes
  accepts_nested_attributes_for :end_of_seasons, :allow_destroy => true

  validates_presence_of :crop_category_id
  validates_presence_of :crop_id

  # if not permanent pasture
  validates_presence_of :plant_date_year, :plant_date_month, :plant_date_day, :planting_method_id, :unless => :isPermanentPasture?
  validates_numericality_of :seeding_rate, :greater_than_or_equal_to => 0, :allow_blank => true, :unless => :isPermanentPasture?
  validates_numericality_of :plant_date_day, :less_than_or_equal_to => 28, :if => 'plant_date_month==2', :message => '^Date incorrect for February', :unless => :isPermanentPasture?

  validates_presence_of :cover_crop_id, :cover_crop_planting_method_id, :if => 'is_cover_crop?'
  validates_presence_of :cover_crop_plant_date_year, :cover_crop_plant_date_month, :cover_crop_plant_date_day, :if => 'is_cover_crop?'
  validates_numericality_of :cover_crop_plant_date_day, :less_than_or_equal_to => 28, :if => 'cover_crop_plant_date_month==2', :message => '^Date incorrect for February', :if => 'is_cover_crop?'

  default_scope :order => 'created_at ASC'

  def isPermanentPasture?
    self.strip==nil ? false : (self.strip.field.field_type.id == 2) # could be nil when duplicating
  end

  # allow duplication
  amoeba do
    enable
  end

  #private
  def reset_ntt_xml
    #  self.strip.field.reset_ntt_xml(self.strip.is_future)
    is_changed = false

    if (self.changed? || self.marked_for_destruction?)
      is_changed = true
      ENV['debug'] += 'Crop rotation changed<br/>'
    end
    if  !is_changed
      self.tillage_operations.each do |tillage_operation|
        if (tillage_operation.changed? || tillage_operation.marked_for_destruction?)
          is_changed = true
          puts 'tillage_operation changed'
          ENV['debug'] += 'Tillage_operation changed<br/>'
          break
        end
      end
    end
    if  !is_changed
      self.manure_fertilizer_applications.each do |manure_fertilizer_application|
        #puts 'manure_fertilizer_application.changed? = ' + manure_fertilizer_application.changed?.to_s
        #puts 'manure_fertilizer_application.destroyed? = ' + manure_fertilizer_application.destroyed?.to_s
        if (manure_fertilizer_application.changed? || manure_fertilizer_application.marked_for_destruction?)

          is_changed = true
          puts 'manure_fertilizer_application changed'
          ENV['debug'] += 'Manure_fertilizer_application changed<br/>'

          break
        end
      end
    end
    if  !is_changed
      self.commercial_fertilizer_applications.each do |commercial_fertilizer_application|
        if (commercial_fertilizer_application.changed? || commercial_fertilizer_application.marked_for_destruction?)
          is_changed = true
          puts 'commercial_fertilizer_application changed'
          ENV['debug'] += 'Commercial_fertilizer_application changed<br/>'
          break
        end
      end
    end
    if  !is_changed
      self.end_of_seasons.each do |end_of_season|
        #puts 'end_of_season.changed? = ' + end_of_season.changed?.to_s
        #puts 'end_of_season.marked_for_destruction?? = ' + end_of_season.marked_for_destruction?.to_s
        #puts 'end_of_season.new_record? = ' + end_of_season.new_record?.to_s
        if (end_of_season.changed? || end_of_season.marked_for_destruction?)
          is_changed = true
          puts 'end_of_season changed'
          ENV['debug'] += 'End_of_season change<br/>'
          break
        end
      end
    end
    puts 'crop rotation changed = ' + is_changed.to_s

    if is_changed
      if (self.strip.is_future && !self.strip.field.ntt_xml_future.nil?)
        self.strip.field.ntt_xml_future = nil
        #self.strip.field.update_column(:ntt_xml_future, nil)
      elsif (!self.strip.is_future && !self.strip.field.ntt_xml_current.nil?)
        self.strip.field.ntt_xml_current = nil
        #self.strip.field.update_column(:ntt_xml_current, nil)
      end
    end
  end
end
