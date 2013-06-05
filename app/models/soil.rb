class Soil < ActiveRecord::Base
  belongs_to :soil_type
  belongs_to :field

  attr_accessible :soil_type_id, :field_id, :clay, :sand, :silt, :bulk_density, :organic_carbon, :slope

  validates_presence_of :field_id, :percent, :mukey, :compname, :muname, :clay, :sand, :bulk_density, :organic_carbon, :slope

  validates_inclusion_of :clay, :in => 0..100, :message => "must be between 0 and 100"
  validates_inclusion_of :sand, :in => 0..100, :message => "must be between 0 and 100"

  validates_numericality_of :bulk_density, :greater_than_or_equal_to => 1.10, :less_than_or_equal_to => 1.79
  validates_numericality_of :organic_carbon, :greater_than_or_equal_to => 0.50, :less_than_or_equal_to => 2.50

end
