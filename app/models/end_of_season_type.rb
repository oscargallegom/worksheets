class EndOfSeasonType < ActiveRecord::Base
  has_many :end_of_seasons

  scope :harvestOnly, where(:id => [626])

end
