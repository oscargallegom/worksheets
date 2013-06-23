class FieldPoultry < ActiveRecord::Base
  belongs_to :field
  belongs_to :animal

  attr_accessible :animal_id, :quantity, :flocks_per_year, :days_in_growing_cycle, :n_excreted, :p205_excreted
end
