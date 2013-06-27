class Livestock < ActiveRecord::Base

  belongs_to :farm
  belongs_to :animal

  attr_accessible :animal_id, :animal_units, :farm_id

  validates_presence_of :animal_id, :message => '^Select an animal'
  validates :animal_units, :presence => {:message => '^Enter animal units'}, :numericality  => {:greater_than_or_equal_to => 0, :message => '^Animal units is not a number'}
  #validates_presence_of :farm_id
end
