class PlantingMethod < ActiveRecord::Base
  # attr_accessible :title, :body

  scope :for_cover_crops, where(:id < 500).order("name asc")

end
