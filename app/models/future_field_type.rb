class FutureFieldType < ActiveRecord::Base
  has_many :fields

  has_many :future_field_type_bmp_types
  has_many :bmp_types, :through => :future_field_type_bmp_types
end
