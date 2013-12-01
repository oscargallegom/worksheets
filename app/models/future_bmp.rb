class FutureBmp < ActiveRecord::Base
  #  if any  change then ntt needs to be called
  after_save :reset_ntt_xml
  after_destroy :reset_ntt_xml

  belongs_to :bmp_type
  belongs_to :field

  attr_accessible :field_id, :bmp_type_id, :is_planned

  validates_presence_of :bmp_type_id

  private
  def reset_ntt_xml
    self.field.reset_ntt_xml(false)
  end

end
