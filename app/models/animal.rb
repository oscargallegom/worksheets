class Animal < ActiveRecord::Base
  has_many :livestock
  has_many :farms, :through => :livestock
end
