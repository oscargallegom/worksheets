class Tmdl < ActiveRecord::Base
  attr_accessible :id, :code, :name, :total_n, :total_p, :total_s_crop, :total_s_hay, :total_s_pasture
  has_many :fields
end
