class TillageOperation < ActiveRecord::Base

  #after_save :reset_ntt_xml
  #after_destroy :reset_ntt_xml

  belongs_to :crop_rotation
  belongs_to :tillage_operation_type

  attr_accessible :start_date_year, :start_date_month, :start_date_day, :tillage_operation_type_id

  validates_presence_of :start_date_year, :start_date_month, :start_date_day, :tillage_operation_type_id
  #validates_numericality_of :start_date_day, :less_than_or_equal_to => 28, :if => 'start_date_month==2', :message => '^Date incorrect for February'

  #private
  #def reset_ntt_xml
  #  self.crop_rotation.strip.field.reset_ntt_xml(self.crop_rotation.strip.is_future)
  #end


  def is_month
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
end
