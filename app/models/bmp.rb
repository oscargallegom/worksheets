
class Bmp < ActiveRecord::Base

  belongs_to :bmp_type
  belongs_to :field #, :inverse_of => :bmps

  attr_accessible :field_id, :bmp_type_id, :is_planned

  validates_presence_of :bmp_type_id

  # allow duplication
  amoeba do
    enable
  end

end
