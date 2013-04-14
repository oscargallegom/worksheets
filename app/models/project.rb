class Project < ActiveRecord::Base
  attr_accessible :farm_notes, :name, :tract_number, :site_name, :site_street_1, :site_street_2, :site_description, :site_city, :site_zip, :site_state_id, :site_county_id, :animal_ids
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  belongs_to :site_state, :class_name => 'State', :foreign_key => 'site_state_id'
  belongs_to :site_county, :class_name => 'State', :foreign_key => 'site_county_id'
  has_many :fields, :dependent => :destroy
  has_and_belongs_to_many :animals

  validates_presence_of :name, :site_name, :site_state_id, :site_county_id

  def has_animals?
    self.new_record? ? false : !self.animals.empty?
  end


  def self.search(search)
    if search
      where('name LIKE ? ', "%#{search}%")
      # find(:all, :conditions => ['title LIKE ? OR description LIKE ?', search_condition, search_condition])
    else
      scoped
    end
  end

end
