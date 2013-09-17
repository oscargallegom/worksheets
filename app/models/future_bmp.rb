class FutureBmp < ActiveRecord::Base
  belongs_to :bmp_type
  belongs_to :field

  attr_accessible :field_id, :bmp_type_id, :is_planned

  validates_presence_of :bmp_type_id
end
