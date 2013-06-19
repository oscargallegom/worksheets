class BmpType < ActiveRecord::Base
  has_many :bmps
  has_many :fields, :through => :bmps
end
