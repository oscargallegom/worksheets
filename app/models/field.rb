class Field < ActiveRecord::Base

  belongs_to :farm
  belongs_to :watershed_segment
  belongs_to :irrigation
  belongs_to :field_type
  belongs_to :p_test_method

  has_many :strips

  has_many :soil_types, :through => :soils
  has_many :soils, :dependent => :destroy

  has_and_belongs_to_many :bmp_types

  attr_accessible :area, :baseline_load, :name, :coordinates
  attr_accessible :name, :field_type_id, :notes
  attr_accessible :acres_from_user, :acres_from_map, :is_acres_from_map, :tile_drainage_depth, :irrigation_id, :efficiency, :fertigation_n, :p_test_method_id, :p_test_value
  attr_accessible :is_forest_buffer, :forest_buffer_average_width, :forest_buffer_length, :is_forest_buffer_planned
  attr_accessible :is_grass_buffer, :grass_buffer_average_width, :grass_buffer_length, :is_grass_buffer_planned

  attr_accessible :soils_attributes
  accepts_nested_attributes_for :soils, :allow_destroy => true

  attr_accessible :strips_attributes
  accepts_nested_attributes_for :strips, :allow_destroy => true

  # TODO: natural sorting
  default_scope :order => 'name ASC'

  # the user can override the acres retrieved from the map
  def acres
    is_acres_from_map ? acres_from_map : acres_from_user
  end

  def forest_buffer_area
    self.forest_buffer_average_width * self.forest_buffer_length / 43560.0 unless (self.forest_buffer_average_width.nil? or self.forest_buffer_length.nil?)
  end
  def grass_buffer_area
    self.grass_buffer_average_width * self.grass_buffer_length / 43560.0 unless (self.grass_buffer_average_width.nil? or self.grass_buffer_length.nil?)
  end
end
