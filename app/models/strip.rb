class Strip < ActiveRecord::Base
  has_many :crop_rotations, :dependent => :destroy, autosave: true #, :inverse_of => :strip
                                                                   #has_many :crops, :through => :crop_rotations

  belongs_to :field #, :inverse_of => :strips

  attr_accessible :length, :is_future

  #validates_numericality_of :length, :greater_than_or_equal_to => 0, :unless => 'field.strips.length == 0'

  default_scope :order => 'created_at ASC'

  # allow duplication
  amoeba do
    enable
  end

end
