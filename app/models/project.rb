class Project < ActiveRecord::Base
  attr_accessible :farm_notes, :name, :tract_number, :site_name, :site_address_1, :site_address_2, :site_city, :site_zip
  belongs_to :owner, :class_name=> 'User', :foreign_key => 'owner_id'
  has_many :fields, :dependent => :destroy
end
