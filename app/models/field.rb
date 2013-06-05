class Field < ActiveRecord::Base

  belongs_to :farm
  belongs_to :irrigation
  belongs_to :field_type
  belongs_to :p_test_method

  has_many :strips

  has_many :soil_types, :through => :soils
  has_many :soils, :dependent => :destroy

  attr_accessible :area, :baseline_load, :name, :coordinates
  attr_accessible :name, :field_type_id, :notes
  attr_accessible :acres, :acres_from_map, :acres_use_map, :tile_drainage_depth, :irrigation_id, :efficiency, :fertigation_n, :p_test_method_id, :p_test_value

  attr_accessible :soils_attributes
  accepts_nested_attributes_for :soils, :allow_destroy => true

  attr_accessible :strips_attributes
  accepts_nested_attributes_for :strips, :allow_destroy => true



end
