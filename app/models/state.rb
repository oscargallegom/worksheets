class State < ActiveRecord::Base
  has_many :counties
  has_many :soil_test_laboratories

  scope :local_states, where(:id => [8, 9, 21, 33, 39, 47, 49]).order("name asc")
end
