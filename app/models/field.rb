class Field < ActiveRecord::Base
  attr_accessible :area, :baseline_load, :name, :coordinates
  belongs_to :farm
end
