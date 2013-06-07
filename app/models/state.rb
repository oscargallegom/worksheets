class State < ActiveRecord::Base
  has_many :counties

  scope :local_states, where(:id => [8, 9, 21, 33, 39, 47, 49]).order("name asc")
end
