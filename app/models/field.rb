class Field < ActiveRecord::Base
  attr_accessible :area, :baseline_load, :name
  belongs_to :project
end
