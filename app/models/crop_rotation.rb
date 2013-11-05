class CropRotation < ActiveRecord::Base

  #  if any  change then ntt needs to be called
  after_save :update_ntt_xml
  after_destroy :update_ntt_xml

  attr_accessor :crop_category_id

  belongs_to :crop #, :inverse_of => :crop_rotations
  belongs_to :strip #, :inverse_of => :crop_rotations

  belongs_to :cover_crop, class_name: 'Crop'

  has_many :grazing_livestocks
  has_many :tillage_operations
  has_many :manure_fertilizer_applications
  has_many :commercial_fertilizer_applications
  has_many :end_of_seasons

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

  private
  def update_ntt_xml
    self.strip.field.update_ntt_xml()
  end

end
