class ManureFertilizerApplication < ActiveRecord::Base

  #after_save :reset_ntt_xml
  #after_destroy :reset_ntt_xml

  belongs_to :crop_rotation
  belongs_to :manure_type
  belongs_to :manure_consistency
  belongs_to :liquid_unit_type

  belongs_to :p_type

  attr_accessible :application_date_year, :application_date_month, :application_date_day, :manure_type_id, :manure_consistency_id, :liquid_unit_type_id, :total_n_concentration, :p_concentration, :p_type_id, :application_rate, :moisture_content, :is_precision_feeding, :is_phytase_treatment, :is_poultry_litter_treatment, :is_incorporated, :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :incorporation_depth

  validates_presence_of :application_date_year, :application_date_month, :application_date_day, :manure_type_id, :manure_consistency_id, :p_type_id

  validates_presence_of :liquid_unit_type_id, :if => 'manure_consistency_id == 265'
  #validates_numericality_of :application_date_day, :less_than_or_equal_to => 28, :if => 'application_date_month==2', :message => '^Date incorrect for February'


  validates_numericality_of :total_n_concentration, :p_concentration, :application_rate, :greater_than_or_equal_to => 0

  validates_inclusion_of :moisture_content, :in => 0..100, :message => 'must be between 0 and 100'

  validates_presence_of :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :if => :is_incorporated?
  validates_numericality_of :incorporation_depth, :greater_than_or_equal_to => 0, :if => :is_incorporated?
  #validates_numericality_of :incorporation_date_day, :less_than_or_equal_to => 28, :if => 'incorporation_date_month==2', :message => '^Date incorrect for February', :if => :is_incorporated?


  #private
  #def reset_ntt_xml
  #  self.crop_rotation.strip.field.reset_ntt_xml(self.crop_rotation.strip.is_future)
  #end


      def is_month
    if self.application_date_month == 1
      "January"
    elsif self.application_date_month == 2
      "Februrary"
    elsif self.application_date_month == 3
      "March"
    elsif self.application_date_month == 4
      "April"
    elsif self.application_date_month == 5
      "May"
    elsif self.application_date_month == 6
      "June"
    elsif self.application_date_month == 7
      "July"
    elsif self.application_date_month == 8
      "August"
    elsif self.application_date_month == 9
      "September"
    elsif self.application_date_month == 10
      "October"
    elsif self.application_date_month == 11
      "November"
    else
      "December"
    end
  end

        def incorporation_is_month
    if self.incorporation_date_month == 1
      "January"
    elsif self.incorporation_date_month == 2
      "Februrary"
    elsif self.incorporation_date_month == 3
      "March"
    elsif self.incorporation_date_month == 4
      "April"
    elsif self.incorporation_date_month == 5
      "May"
    elsif self.incorporation_date_month == 6
      "June"
    elsif self.incorporation_date_month == 7
      "July"
    elsif self.incorporation_date_month == 8
      "August"
    elsif self.incorporation_date_month == 9
      "September"
    elsif self.incorporation_date_month == 10
      "October"
    elsif self.incorporation_date_month == 11
      "November"
    else
      "December"
    end
  end

end
