class Soil < ActiveRecord::Base
  belongs_to :soil_type
  belongs_to :field

  attr_accessible :soil_type_id, :field_id, :percent_clay, :percent_sand, :percent_silt, :bulk_density, :organic_carbon, :slope

  validates_presence_of :field_id, :percent, :map_unit_key, :component_name, :map_unit_name, :slope

  validates_inclusion_of :percent_clay, :in => 0..100, :message => 'must be between 0 and 100'
  validates_inclusion_of :percent_sand, :in => 0..100, :message => 'must be between 0 and 100'

  validates_numericality_of :bulk_density, :greater_than_or_equal_to => 1.10, :less_than_or_equal_to => 1.79
  validates_numericality_of :organic_carbon, :greater_than_or_equal_to => 0.50, :less_than_or_equal_to => 2.50

  validates_inclusion_of :slope, :in => 0..100, :message => 'must be between 0 and 100'

end
