class GrazingLivestock < ActiveRecord::Base
  belongs_to :crop_rotation
  belongs_to :animal

  attr_accessible :start_date_year, :start_date_month, :start_date_day, :end_date_year, :end_date_month, :end_date_day, :animal_id, :animal_units, :hours_grazed, :precision_feeding, :consecutive_hours, :rest_time, :paddocks, :supplemental_feed, :round_bales

  validates_presence_of :start_date_year, :start_date_month, :start_date_day, :end_date_year, :end_date_month, :end_date_day, :animal_id

  validates_numericality_of :animal_units, :greater_than_or_equal_to => 0
 # validates_numericality_of :hours_grazed, :greater_than_or_equal_to => 0
  #validates_numericality_of :start_date_day, :less_than_or_equal_to => 28, :if => 'start_date_month==2', :message => '^Date incorrect for February'
  #validates_numericality_of :end_date_day, :less_than_or_equal_to => 28, :if => 'end_date_month==2', :message => '^Date incorrect for February'


  def display_start_month
    if self.start_date_month == 1
      "January"
    elsif self.start_date_month == 2
      "Februrary"
    elsif self.start_date_month == 3
      "March"
    elsif self.start_date_month == 4
      "April"
    elsif self.start_date_month == 5
      "May"
    elsif self.start_date_month == 6
      "June"
    elsif self.start_date_month == 7
      "July"
    elsif self.start_date_month == 8
      "August"
    elsif self.start_date_month == 9
      "September"
    elsif self.start_date_month == 10
      "October"
    elsif self.start_date_month == 11
      "November"
    else
      "December"
    end
  end


   def display_end_month
    if self.end_date_month == 1
      "January"
    elsif self.end_date_month == 2
      "Februrary"
    elsif self.end_date_month == 3
      "March"
    elsif self.end_date_month == 4
      "April"
    elsif self.end_date_month == 5
      "May"
    elsif self.end_date_month == 6
      "June"
    elsif self.end_date_month == 7
      "July"
    elsif self.end_date_month == 8
      "August"
    elsif self.end_date_month == 9
      "September"
    elsif self.end_date_month == 10
      "October"
    elsif self.end_date_month == 11
      "November"
    else
      "December"
    end
  end

end
