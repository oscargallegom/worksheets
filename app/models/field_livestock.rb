class FieldLivestock < ActiveRecord::Base
  belongs_to :field
  belongs_to :animal

  attr_accessible  :animal_id, :total_manure, :quantity, :days_per_year_confined, :hours_per_day_confined, :n_excreted, :p205_excreted
end
