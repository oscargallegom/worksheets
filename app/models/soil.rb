class Soil < ActiveRecord::Base

  #  if any  change then ntt needs to be called
  #after_save :reset_ntt_xml
  #after_destroy :reset_ntt_xml

  # belongs_to :soil_type      # soil type old ???
  belongs_to :field #, :inverse_of => :soils

  attr_accessible :field_id, :percent_clay, :percent_sand, :percent_silt, :bulk_density, :organic_carbon, :slope

  validates_presence_of :percent, :map_unit_key, :component_name, :map_unit_name, :slope

  validates_inclusion_of :percent_clay, :in => 0..100, :message => 'must be between 0 and 100'
  validates_inclusion_of :percent_sand, :in => 0..100, :message => 'must be between 0 and 100'

  #validates_numericality_of :bulk_density, :greater_than_or_equal_to => 1.10, :less_than_or_equal_to => 1.79
  #validates_numericality_of :organic_carbon, :greater_than_or_equal_to => 0.50, :less_than_or_equal_to => 2.50

  validates_inclusion_of :slope, :in => 0..100, :message => 'must be between 0 and 100'

  # if duplicating farm, skip validation
  #def isnt_duplicate?
  #  !(self.field.nil? || self.field.farm.nil?)
  #end

  # allow duplication
  amoeba do
    enable
  end

  #private
  #def reset_ntt_xml
  #  if (self.changed?)
  #    self.field.reset_ntt_xml(false)
  #    self.field.reset_ntt_xml(true)
  #  end
  #end

end
