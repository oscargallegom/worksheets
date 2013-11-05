class GrazingLivestock < ActiveRecord::Base
  belongs_to :crop_rotation
  belongs_to :animal

  attr_accessible :start_date_year, :start_date_month, :start_date_day, :end_date_year, :end_date_month, :end_date_day, :animal_id, :animal_units, :hours_grazed, :precision_feeding

  validates_presence_of :start_date_year, :start_date_month, :start_date_day, :end_date_year, :end_date_month, :end_date_day, :animal_id

  validates_numericality_of :animal_units, :greater_than_or_equal_to => 0
  validates_numericality_of :hours_grazed, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 24
  validates_numericality_of :start_date_day, :less_than_or_equal_to => 28, :if => 'start_date_month==2', :message => '^Date incorrect for February'
  validates_numericality_of :end_date_day, :less_than_or_equal_to => 28, :if => 'end_date_month==2', :message => '^Date incorrect for February'


end
