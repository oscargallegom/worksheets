class Livestock < ActiveRecord::Base
  belongs_to :farm
  belongs_to :animal

  attr_accessible :animal_id, :animal_units, :farm_id

  validates_presence_of :animal_id, :message => '^Select an animal'
  validates_numericality_of  animal_units, :greater_than_or_equal_to => 0, :message => '^Animal units is not a number'
end
