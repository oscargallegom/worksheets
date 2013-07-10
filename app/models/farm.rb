class Farm < ActiveRecord::Base

  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  #belongs_to :site_state, :class_name => 'State', :foreign_key => 'site_state_id'
  #belongs_to :site_county, :class_name => 'State', :foreign_key => 'site_county_id'
  belongs_to :state, :foreign_key => 'site_state_id'
  belongs_to :county, :foreign_key => 'site_county_id'
  belongs_to :generator_type

  has_many :fields, :dependent => :destroy

  has_many :animals, :through => :livestock
  has_many :livestock, :dependent => :destroy

  attr_accessible :name, :farm_notes, :tract_number, :generator_type_id, :site_name, :site_street_1, :site_street_2, :site_description, :site_city, :site_zip, :site_state_id, :site_county_id, :coordinates

  attr_accessible :livestock_attributes
  accepts_nested_attributes_for :livestock, :allow_destroy => true

  validates_presence_of :name, :message => '^Farm name can''t be blank'
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
      where(' id || \'\' like ? OR name LIKE ? ', "%#{search}%", "%#{search}%" )
      # find(:all, :conditions => ['id' LIKE ? OR title LIKE ? OR description LIKE ?', search_condition, search_condition, search_condition])
    else
      scoped
    end
  end

end