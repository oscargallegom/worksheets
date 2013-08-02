class FieldLivestock < ActiveRecord::Base
  belongs_to :field #, :inverse_of => :field_livestocks
  belongs_to :animal

  attr_accessible :animal_id, :total_manure, :quantity, :days_per_year_confined, :hours_per_day_confined, :average_weight, :n_excreted, :p205_excreted

  validates_presence_of :animal_id
  validates_numericality_of :total_manure, :quantity, :average_weight, :greater_than_or_equal_to => 0
  validates_numericality_of :days_per_year_confined, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 365
  validates_numericality_of :hours_per_day_confined, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 24

  # allow duplication
  amoeba do
    enable
  end

end
