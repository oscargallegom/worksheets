class Strip < ActiveRecord::Base
  has_many :crop_rotations
  has_many :crops, :through => :crop_rotations

  belongs_to :field

  attr_accessible :length

  default_scope :order => 'created_at ASC'

end
