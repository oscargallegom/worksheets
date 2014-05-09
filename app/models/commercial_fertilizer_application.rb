class CommercialFertilizerApplication < ActiveRecord::Base

  #after_save :reset_ntt_xml
  #after_destroy :reset_ntt_xml

  belongs_to :crop_rotation
  belongs_to :p_type

  attr_accessible :application_date_year, :application_date_month, :application_date_day, :total_n_applied, :total_p_applied, :p_type_id, :is_incorporated
  attr_accessible :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :incorporation_depth

  validates_presence_of :application_date_year, :application_date_month, :application_date_day

  validates_presence_of :total_n_applied, :if => 'total_p_applied.nil?', :message => '^You must enter a value for total N applied or total P applied (commercial fertilizer applications section).'
  validates_presence_of :total_p_applied, :if => 'total_n_applied.nil?', :message => '^'
  validates_presence_of :p_type_id, :if => '!total_p_applied.nil? && total_p_applied > 0'

  validates_presence_of :incorporation_date_year, :incorporation_date_month, :incorporation_date_day, :if => :is_incorporated?
  validates_numericality_of :incorporation_depth, :greater_than_or_equal_to => 0, :if => :is_incorporated?

  #validates_numericality_of :application_date_day, :less_than_or_equal_to => 28, :if => 'application_date_month==2', :message => '^Date incorrect for February'

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
    elsif self.incorporationn_date_month == 10
      "October"
    elsif self.incorporation_date_month == 11
      "November"
    else
      "December"
    end
  end


end
