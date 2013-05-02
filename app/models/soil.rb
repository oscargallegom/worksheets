class Soil < ActiveRecord::Base
  belongs_to :soil_type
  belongs_to :field

  attr_accessible :soil_type_id, :field_id, :clay, :bulk_density, :organic_carbon, :slope
end
