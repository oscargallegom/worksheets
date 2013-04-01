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

# User.delete_all
# User.where(:email => 'admin@admin.com').first.destroy
User.delete_all
User.create!({:email => 'admin@admin.com', :password => '123', :first_name => 'Admin', :last_name => '1', :approved => true , :roles => Role.where(:id => [1,2]) }, :without_protection => true)
User.create!({:email => 'tester1@tester1.com', :password => '123', :first_name => 'Tester', :last_name => '1', :approved => true  }, :without_protection => true)
User.create!({:email => 'tester2@tester2.com', :password => '123', :first_name => 'Tester', :last_name => '2', :approved => true  }, :without_protection => true)
User.create!({:email => 'tester3@tester3.com', :password => '123', :first_name => 'Tester', :last_name => '3', :approved => true  }, :without_protection => true)

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

