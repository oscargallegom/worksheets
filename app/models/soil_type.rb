class SoilType < ActiveRecord::Base
  has_many :soils
  has_many :fields, :through => :soils
end
