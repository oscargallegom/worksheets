class HarvestOperation < ActiveRecord::Base
  belongs_to :crop_rotation

  attr_accessible :start_date_year, :start_date_month, :start_date_day

end
