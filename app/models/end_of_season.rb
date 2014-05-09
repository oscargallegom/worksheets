class EndOfSeason < ActiveRecord::Base

  #after_save :reset_ntt_xml
  #after_destroy :reset_ntt_xml

  belongs_to :crop_rotation
  belongs_to :end_of_season_type

  attr_accessible :end_of_season_type_id, :year, :month, :day, :is_harvest_as_silage

  validates_presence_of :end_of_season_type_id, :year, :month, :day
  #validates_numericality_of :day, :less_than_or_equal_to => 28, :if => 'month==2', :message => '^Date incorrect for February'


  # allow duplication
  amoeba do
    enable
  end

  #def reset_ntt_xml
  #  self.crop_rotation.strip.field.reset_ntt_xml(self.crop_rotation.strip.is_future)
  #end

      def is_month
    if self.month == 1
      "January"
    elsif self.month == 2
      "Februrary"
    elsif self.month == 3
      "March"
    elsif self.month == 4
      "April"
    elsif self.month == 5
      "May"
    elsif self.month == 6
      "June"
    elsif self.month == 7
      "July"
    elsif self.month == 8
      "August"
    elsif self.month == 9
      "September"
    elsif self.month == 10
      "October"
    elsif self.month == 11
      "November"
    else
      "December"
    end
  end

end
