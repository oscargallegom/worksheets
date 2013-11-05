class CommercialFertilizerApplication < ActiveRecord::Base
  belongs_to :crop_rotation
  belongs_to :p_type

  attr_accessible :application_date_year, :application_date_month, :application_date_day, :total_n_applied, :total_p_applied, :p_type_id, :is_incorporated
  attr_accessible :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :incorporation_depth

  validates_presence_of :application_date_year, :application_date_month, :application_date_day

  validates_presence_of :total_n_applied, :if => 'total_p_applied.nil?', :message => '^You must enter a value for total N applied or total P applied (commercial fertilizer applications section).'
  validates_presence_of :total_p_applied, :if => 'total_n_applied.nil?', :message => '^'
  validates_presence_of :p_type_id, :if => '!total_p_applied.nil?'

  validates_presence_of :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :if => :is_incorporated?
  validates_numericality_of :incorporation_depth, :greater_than_or_equal_to => 0, :if => :is_incorporated?

  validates_numericality_of :application_date_day, :less_than_or_equal_to => 28, :if => 'application_date_month==2', :message => '^Date incorrect for February'
end
