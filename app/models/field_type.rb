class FieldType < ActiveRecord::Base
  has_many :fields

  has_many :field_type_bmp_types
  has_many :bmp_types, :through => :field_type_bmp_types
  scope :convertable_fields, where(:id => [1,2,3])
end
