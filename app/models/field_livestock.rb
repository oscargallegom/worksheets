class FieldLivestock < ActiveRecord::Base

  #  if any  change then ntt needs to be called
  after_save :update_ntt_xml
  after_destroy :update_ntt_xml

  # for validation puposes, need to know field.livestock_input_method_id
  attr_accessor :livestock_input_method_id

  belongs_to :field
  belongs_to :animal

  attr_accessible :livestock_input_method_id, :animal_id, :total_manure, :quantity, :days_per_year_confined, :hours_per_day_confined, :average_weight, :n_excreted, :p205_excreted

  validates_presence_of :animal_id
  # if input method is average per type, no total manure
  validates_numericality_of :total_manure, :n_excreted, :p205_excreted, :greater_than_or_equal_to => 0, :if => :totals_per_type?
  # if input method is totals per type, no quantity, day, hour, average
  validates_numericality_of :quantity, :average_weight, :greater_than_or_equal_to => 0, :if => :average_per_type?
  validates_numericality_of :days_per_year_confined, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 365, :if => :average_per_type?
  validates_numericality_of :hours_per_day_confined, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 24, :if => :average_per_type?

  def totals_per_type?
    livestock_input_method_id == '1'
  end

  def average_per_type?
    livestock_input_method_id == '2'
  end

  # allow duplication
  amoeba do
    enable
  end

  private
  def update_ntt_xml
    self.field.update_ntt_xml()
  end

end
