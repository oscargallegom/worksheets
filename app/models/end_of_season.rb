class EndOfSeason < ActiveRecord::Base
  belongs_to :crop_rotation
  belongs_to :end_of_season_type

  attr_accessible :end_of_season_type_id, :year, :month, :day, :is_harvest_as_silage

  validates_presence_of :end_of_season_type_id, :year, :month, :day

  # allow duplication
  amoeba do
    enable
  end

end
