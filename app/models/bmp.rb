class Bmp < ActiveRecord::Base
  belongs_to :bmp_type

  attr_accessible :field_id, :bmp_type_id, :acres, :is_planned

end
