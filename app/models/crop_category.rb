class CropCategory < ActiveRecord::Base
  has_many :crops

  default_scope :order => 'name ASC'
end
