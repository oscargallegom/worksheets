class Strip < ActiveRecord::Base
  #  if any  change then ntt needs to be called
  after_save :update_ntt_xml
  after_destroy :update_ntt_xml

  has_many :crop_rotations, :dependent => :destroy, autosave: true #, :inverse_of => :strip
                                                                   #has_many :crops, :through => :crop_rotations

  belongs_to :field #, :inverse_of => :strips

  attr_accessible :length, :is_future

  # lenght can't be blank unless there is only one strip
  validates_presence_of :length, :unless => 'field.strips.length == 1'
  validates_numericality_of :length, :greater_than_or_equal_to => 0, :allow_blank => true, :unless => 'field.strips.length == 1'

  default_scope :order => 'created_at ASC'

  # allow duplication
  amoeba do
    enable
  end

  private
  def update_ntt_xml
      self.field.update_ntt_xml()
  end

end
