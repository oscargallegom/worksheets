class EndOfSeason < ActiveRecord::Base
  belongs_to :crop_rotation
  belongs_to :end_of_season_type

  attr_accessible :end_of_season_type_id, :year, :month, :day, :is_harvest_as_silage

  validates_presence_of :end_of_season_type_id, :year, :month, :day
  validates_numericality_of :day, :less_than_or_equal_to => 28, :if => 'month==2', :message => '^Date incorrect for February'


  # allow duplication
  amoeba do
    enable
  end

end
