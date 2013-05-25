class Crop < ActiveRecord::Base
  # has_many :crop_rotations
  # has_many :strips, :through => :crop_rotations

  belongs_to :crop_category
end
