class SoilTestLaboratory < ActiveRecord::Base
  belongs_to :state
  has_many :soil_p_extractants

  scope :in_Delaware, where(:state_id => 9)
  scope :in_Maryland, where(:state_id => 21)
  scope :in_Pennsylvania, where(:state_id => 39)
  scope :in_Virginia, where(:state_id => 47)
  scope :in_WestVirginia, where(:state_id => 49)

end
