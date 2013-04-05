# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.delete_all
Role.create!({:id => 1, :name => 'User Administrator'} , :without_protection => true)
Role.create!({:id => 2, :name => 'Project Administrator'}, :without_protection => true)
Role.create!({:id => 3, :name => 'Basic User'}, :without_protection => true)

UserType.delete_all
UserType.create!({:id => 1, :name => 'Landowner/producer'}, :without_protection => true)
UserType.create!({:id => 2, :name => 'Agribusiness/consultant'}, :without_protection => true)
UserType.create!({:id => 3, :name => 'NGO/Non-profit'}, :without_protection => true)
UserType.create!({:id => 4, :name => 'Government'}, :without_protection => true)
UserType.create!({:id => 5, :name => 'Soil Conservation District'}, :without_protection => true)
UserType.create!({:id => 6, :name => 'Regulated Entity'}, :without_protection => true)
UserType.create!({:id => 99, :name => 'Other'}, :without_protection => true)


User.delete_all
User.create!({:id => 1, :username => 'admin', :password => '123', :user_type_id => 1, :first_name => 'Admin', :last_name => '1', :email => 'oleblond@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 1, :zip => '12345', :org_name => 'My Org', :job_title => 'Admin', :approved => true , :roles => Role.where(:id => [1,2]) }, :without_protection => true)
User.create!({:id => 2, :username => 'tester_1', :password => '123', :user_type_id => 1, :first_name => 'Tester', :last_name => '1', :email => 'tester_1@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 1, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true  }, :without_protection => true)
User.create!({:id => 3, :username => 'tester_2', :password => '123', :user_type_id => 2, :first_name => 'Tester', :last_name => '2', :email => 'tester_2@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 1, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true }, :without_protection => true)
# User.create!({:id => 2, :email => 'tester1@tester1.com', :password => '123', :first_name => 'Tester', :last_name => '1', :approved => true  }, :without_protection => true)
# User.create!({:id => 3, :email => 'tester2@tester2.com', :password => '123', :first_name => 'Tester', :last_name => '2', :approved => true  }, :without_protection => true)
# User.create!({:id => 4, :email => 'tester3@tester3.com', :password => '123', :first_name => 'Tester', :last_name => '3', :approved => true  }, :without_protection => true)

#Roles_Users.delete_all
#Roles_Users.create({:role => role, :user => user})



State.delete_all
State.create!({:name => 'Virginia'}, :without_protection => true)
State.create!({:name => 'Maryland'}, :without_protection => true)
State.create!({:name => 'North Carolina'}, :without_protection => true)
State.create!({:name => 'Florida'}, :without_protection => true)

City.delete_all
City.create!({:name => "Arlington", :state => State.find_by_name("Virginia")}, :without_protection => true)
City.create!({:name => "Vienna", :state => State.find_by_name("Virginia")}, :without_protection => true)
City.create!({:name => "Alexandria", :state => State.find_by_name("Virginia")}, :without_protection => true)

City.create!({:name => "Baltimore", :state => State.find_by_name("Maryland")}, :without_protection => true)

