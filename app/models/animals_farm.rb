class AnimalsFarm < ActiveRecord::Base
  belongs_to :farm
  belongs_to :animal

end
