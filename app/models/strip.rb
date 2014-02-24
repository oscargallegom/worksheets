class Strip < ActiveRecord::Base
  #  if any  change then ntt needs to be called
  #after_save :reset_ntt_xml
  #after_destroy :update_ntt_xml

  has_many :crop_rotations, :dependent => :destroy, autosave: true #, :inverse_of => :strip
                                                                   #has_many :crops, :through => :crop_rotations

  belongs_to :field #, :inverse_of => :strips

  attr_accessible :length, :is_future

  # length can't be blank unless there is only one strip
  validates_presence_of :length
  validates_numericality_of :length, :greater_than => 0, :allow_blank => true, :unless => 'field.strips.length == 1'

  default_scope :order => 'created_at ASC'

  # allow duplication
  amoeba do
    enable
  end

  #private
  #def reset_ntt_xml
  #  self.field.reset_ntt_xml(is_future)
  #end

end
