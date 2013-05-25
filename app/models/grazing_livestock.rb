class GrazingLivestock < ActiveRecord::Base
  belongs_to :crop_rotation
  belongs_to :animal

  attr_accessible :start_date_year, :start_date_month, :start_date_day, :end_date_year, :end_date_month, :end_date_day, :animal_id, :animal_units, :hours_grazed, :precision_feeding

end
