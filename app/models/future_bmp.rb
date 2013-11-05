class FutureBmp < ActiveRecord::Base
  #  if any  change then ntt needs to be called
  after_save :update_ntt_xml
  after_destroy :update_ntt_xml

  belongs_to :bmp_type
  belongs_to :field

  attr_accessible :field_id, :bmp_type_id, :is_planned

  validates_presence_of :bmp_type_id

  private
  def update_ntt_xml
    self.field.update_ntt_xml()
  end

end
