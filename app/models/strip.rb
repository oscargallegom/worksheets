class Strip < ActiveRecord::Base
  has_many :crop_rotations
  has_many :crops, :through => :crop_rotations

  belongs_to :field

  attr_accessible :length

  validates_numericality_of :length, :greater_than_or_equal_to => 0, :unless => 'field.strips.length == 0'

  default_scope :order => 'created_at ASC'

end
