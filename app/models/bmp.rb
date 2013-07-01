class Bmp < ActiveRecord::Base
  belongs_to :bmp_type

  attr_accessible :field_id, :bmp_type_id, :acres, :is_planned

  validates_presence_of :bmp_type_id
  validates_numericality_of :acres, :greater_than_or_equal_to => 0

end
