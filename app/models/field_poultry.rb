class FieldPoultry < ActiveRecord::Base
  belongs_to :field
  belongs_to :poultry

  attr_accessible :poultry_id, :quantity, :flocks_per_year, :days_in_growing_cycle, :n_excreted, :p205_excreted

  validates_presence_of :poultry_id
  validates_numericality_of :quantity, :flocks_per_year, :greater_than_or_equal_to => 0
  validates_numericality_of :days_in_growing_cycle, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 365
end
