class Animal < ActiveRecord::Base
  has_many :livestock
  has_many :farms, :through => :livestock

  has_many :field_livestocks
  has_many :field_poultries

  scope :animal, where(:category_id => 1).order("name asc")
  scope :poultry, where(:category_id => 2).order("name asc")

end
