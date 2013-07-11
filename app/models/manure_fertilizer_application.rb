class ManureFertilizerApplication < ActiveRecord::Base
  belongs_to :crop_rotation
  belongs_to :manure_type
  belongs_to :manure_consistency
  belongs_to :liquid_unit_type

  belongs_to :p_type

  attr_accessible :application_date_year, :application_date_month, :application_date_day, :manure_type_id, :manure_consistency_id, :liquid_unit_type_id, :total_n_concentration, :p_concentration, :p_type_id, :application_rate, :moisture_content, :is_precision_feeding, :is_phytase_treatment, :is_poultry_litter_treatment, :is_incorporated, :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :incorporation_depth

  validates_presence_of :application_date_year, :application_date_month, :application_date_day, :manure_type_id, :manure_consistency_id, :p_type_id

  validates_presence_of :liquid_unit_type_id, :if => 'manure_consistency_id == 1'

  validates_numericality_of :total_n_concentration, :p_concentration, :application_rate, :greater_than_or_equal_to => 0

  validates_inclusion_of :moisture_content, :in => 0..100, :message => 'must be between 0 and 100'

  validates_presence_of :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :if => :is_incorporated?
  validates_numericality_of :incorporation_depth, :greater_than_or_equal_to => 0, :if => :is_incorporated?

end
