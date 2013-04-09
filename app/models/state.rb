class State < ActiveRecord::Base
  has_many :counties

  scope :local_states, where(:id => [1, 50]).order("name asc")
end
