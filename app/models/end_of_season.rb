class EndOfSeason < ActiveRecord::Base
  belongs_to :crop_rotation
  belongs_to :end_of_season_type

  attr_accessible :end_of_season_type_id, :year, :month, :day
end
