class BmpType < ActiveRecord::Base
  has_many :bmps
  has_many :fields, :through => :bmps

  has_many :field_type_bmp_types
  has_many :field_types, :through => :field_type_bmp_types
  has_many :future_field_type_bmp_types
  has_many :future_field_types, :through => :future_field_type_bmp_types
end
