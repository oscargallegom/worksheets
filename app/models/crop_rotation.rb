class CropRotation < ActiveRecord::Base
  belongs_to :crop
  belongs_to :strip

  has_many :grazing_livestocks
  has_many :tillage_operations
  has_many :harvest_operations

  attr_accessible :strip_id, :crop_category_id, :crop_id, :plant_date_year, :plant_date_month, :plant_date_day, :planting_method_id, :seeding_rate, :end_of_season_year, :end_of_season_month, :end_of_season_day

  attr_accessible :grazing_livestocks_attributes
  accepts_nested_attributes_for :grazing_livestocks, :allow_destroy => true

  attr_accessible :tillage_operations_attributes
  accepts_nested_attributes_for :tillage_operations, :allow_destroy => true

  attr_accessible :harvest_operations_attributes
  accepts_nested_attributes_for :harvest_operations, :allow_destroy => true

  default_scope :order => 'created_at ASC'
end
