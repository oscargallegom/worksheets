class Livestock < ActiveRecord::Base
  belongs_to :farm
  belongs_to :animal

  attr_accessible :animal_id, :animal_units, :farm_id

  validates_presence_of :animal_id, :message => '^Select an animal.'
  validates_presence_of :animal_units, :message => '^Enter animal units.'
  validates_presence_of :farm_id
end
