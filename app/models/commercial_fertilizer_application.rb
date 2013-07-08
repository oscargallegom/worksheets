class CommercialFertilizerApplication < ActiveRecord::Base
  belongs_to :crop_rotation

  attr_accessible :application_date_year, :application_date_month, :application_date_day, :total_n_applied, :total_p_applied, :is_incorporated
  attr_accessible :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :incorporation_depth

  validates_presence_of :application_date_year, :application_date_month, :application_date_day, :total_n_applied, :total_p_applied
  validates_presence_of :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :if => :is_incorporated?
  validates_numericality_of :incorporation_depth, :greater_than_or_equal_to => 0, :if => :is_incorporated?
end
