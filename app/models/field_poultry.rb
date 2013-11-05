class FieldPoultry < ActiveRecord::Base

  #  if any  change then ntt needs to be called
  after_save :update_ntt_xml
  after_destroy :update_ntt_xml

  belongs_to :field #, :inverse_of => :field_poultry
  belongs_to :animal

  attr_accessible :poultry_id, :quantity, :flocks_per_year, :days_in_growing_cycle, :n_excreted, :p205_excreted

  validates_presence_of :poultry_id
  validates_numericality_of :quantity, :flocks_per_year, :n_excreted, :p205_excreted, :greater_than_or_equal_to => 0
  validates_numericality_of :days_in_growing_cycle, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 365

  # allow duplication
  amoeba do
    enable
  end

  private
  def update_ntt_xml
    self.field.update_ntt_xml()
  end

end
