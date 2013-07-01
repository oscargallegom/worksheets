class TillageOperation < ActiveRecord::Base
  belongs_to :tillage_operation_type

  attr_accessible :start_date_year, :start_date_month, :start_date_day, :tillage_operation_type_id

  validates_presence_of :start_date_year, :start_date_month, :start_date_day, :tillage_operation_type_id
end
