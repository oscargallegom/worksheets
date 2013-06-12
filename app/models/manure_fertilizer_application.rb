class ManureFertilizerApplication < ActiveRecord::Base
  belongs_to :crop_rotation
  belongs_to :manure_type
  belongs_to :manure_consistency
  belongs_to :liquid_unit_type
  belongs_to :p_type

  attr_accessible :application_date_year, :application_date_month, :application_date_day, :manure_type_id, :manure_consistency_id, :liquid_unit_type_id, :total_n_concentration, :p_concentration, :p_type_id, :application_rate, :moisture_content, :is_precision_feeding, :is_phytase_treatment, :is_poultry_litter_treatment, :is_incorporated, :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :incorporation_depth

end
