class Crop < ActiveRecord::Base
  # has_many :crop_rotations
  # has_many :strips, :through => :crop_rotations

  belongs_to :crop_category

  default_scope :order => 'name ASC'
  scope :coverCrops, where(:crop_category_id => [6]).order("name asc")

end
