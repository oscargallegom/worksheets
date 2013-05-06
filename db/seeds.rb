# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.delete_all
Role.create!({:id => 1, :name => 'Project Administrator'}, :without_protection => true)
Role.create!({:id => 2, :name => 'User Administrator'}, :without_protection => true)
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
User.create!({:id => 1, :username => 'super_admin', :password => '123', :user_type_id => 1, :first_name => 'Super Admin', :last_name => '1', :email => 'oleblond@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 1, :zip => '12345', :org_name => 'My Org', :job_title => 'Admin', :approved => true, :roles => Role.where(:id => [1, 2])}, :without_protection => true)
User.create!({:id => 2, :username => 'user_admin', :password => '123', :user_type_id => 1, :first_name => 'User Admin', :last_name => '1', :email => 'olivier_leblond@hotmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 1, :zip => '12345', :org_name => 'My Org', :job_title => 'Admin', :approved => true, :roles => Role.where(:id => [1, 2])}, :without_protection => true)
User.create!({:id => 3, :username => 'tester_1', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '1', :email => 'tester_1@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 1, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
User.create!({:id => 4, :username => 'tester_2', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '2', :email => 'tester_2@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 2, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
User.create!({:id => 5, :username => 'tester_3', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '3', :email => 'tester_3@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 3, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
User.create!({:id => 6, :username => 'tester_4', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '4', :email => 'tester_4@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 4, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
User.create!({:id => 7, :username => 'tester_5', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '5', :email => 'tester_5@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 5, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
User.create!({:id => 8, :username => 'tester_6', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '6', :email => 'tester_6@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 6, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
User.create!({:id => 9, :username => 'tester_7', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '7', :email => 'tester_7@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 7, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
User.create!({:id => 10, :username => 'tester_8', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '8', :email => 'tester_8@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 8, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
User.create!({:id => 11, :username => 'tester_9', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '9', :email => 'tester_9@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 9, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
User.create!({:id => 12, :username => 'tester_10', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '10', :email => 'tester_10@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 10, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
User.create!({:id => 13, :username => 'tester_11', :password => '123', :user_type_id => 3, :first_name => 'Tester', :last_name => '11', :email => 'tester_11@gmail.com', :phone => '123 456 7890', :street1 => 'Main Street', :city => 'Arlington', :state_id => 11, :zip => '12345', :org_name => 'My Org', :job_title => 'Tester', :approved => true}, :without_protection => true)
# User.create!({:id => 2, :email => 'tester1@tester1.com', :password => '123', :first_name => 'Tester', :last_name => '1', :approved => true  }, :without_protection => true)
# User.create!({:id => 3, :email => 'tester2@tester2.com', :password => '123', :first_name => 'Tester', :last_name => '2', :approved => true  }, :without_protection => true)
# User.create!({:id => 4, :email => 'tester3@tester3.com', :password => '123', :first_name => 'Tester', :last_name => '3', :approved => true  }, :without_protection => true)

#Roles_Users.delete_all
#Roles_Users.create({:role => role, :user => user})


State.delete_all
states = [
    {:id => 1, :name => 'Alabama', :abbreviation => 'AL'},
    {:id => 2, :name => 'Alaska', :abbreviation => 'AK'},
    {:id => 3, :name => 'Arizona', :abbreviation => 'AZ'},
    {:id => 4, :name => 'Arkansas', :abbreviation => 'AR'},
    {:id => 5, :name => 'California', :abbreviation => 'CA'},
    {:id => 6, :name => 'Colorado', :abbreviation => 'CO'},
    {:id => 7, :name => 'Connecticut', :abbreviation => 'CT'},
    {:id => 8, :name => 'Delaware', :abbreviation => 'DE'},
    {:id => 9, :name => 'Florida', :abbreviation => 'FL'},
    {:id => 10, :name => 'Georgia', :abbreviation => 'GA'},
    {:id => 11, :name => 'Hawaii', :abbreviation => 'HI'},
    {:id => 12, :name => 'Idaho', :abbreviation => 'ID'},
    {:id => 13, :name => 'Illinois', :abbreviation => 'IL'},
    {:id => 14, :name => 'Indiana', :abbreviation => 'IN'},
    {:id => 15, :name => 'Iowa', :abbreviation => 'IA'},
    {:id => 16, :name => 'Kansas', :abbreviation => 'KS'},
    {:id => 17, :name => 'Kentucky', :abbreviation => 'KY'},
    {:id => 18, :name => 'Louisiana', :abbreviation => 'LA'},
    {:id => 19, :name => 'Maine', :abbreviation => 'ME'},
    {:id => 20, :name => 'Maryland', :abbreviation => 'MD'},
    {:id => 21, :name => 'Massachusetts', :abbreviation => 'MA'},
    {:id => 22, :name => 'Michigan', :abbreviation => 'MI'},
    {:id => 23, :name => 'Minnesota', :abbreviation => 'MN'},
    {:id => 24, :name => 'Mississippi', :abbreviation => 'MS'},
    {:id => 25, :name => 'Missouri', :abbreviation => 'MO'},
    {:id => 26, :name => 'Montana', :abbreviation => 'MT'},
    {:id => 27, :name => 'Nebraska', :abbreviation => 'NE'},
    {:id => 28, :name => 'Nevada', :abbreviation => 'NV'},
    {:id => 29, :name => 'New Hampshire', :abbreviation => 'NH'},
    {:id => 30, :name => 'New Jersey', :abbreviation => 'NJ'},
    {:id => 31, :name => 'New Mexico', :abbreviation => 'NM'},
    {:id => 32, :name => 'New York', :abbreviation => 'NY'},
    {:id => 33, :name => 'North Carolina', :abbreviation => 'NC'},
    {:id => 34, :name => 'North Dakota', :abbreviation => 'ND'},
    {:id => 35, :name => 'Ohio', :abbreviation => 'OH'},
    {:id => 36, :name => 'Oklahoma', :abbreviation => 'OK'},
    {:id => 37, :name => 'Oregon', :abbreviation => 'OR'},
    {:id => 38, :name => 'Pennsylvania', :abbreviation => 'PA'},
    {:id => 39, :name => 'Rhode Island', :abbreviation => 'RI'},
    {:id => 40, :name => 'South Carolina', :abbreviation => 'SC'},
    {:id => 41, :name => 'South Dakota', :abbreviation => 'SD'},
    {:id => 42, :name => 'Tennessee', :abbreviation => 'TN'},
    {:id => 43, :name => 'Texas', :abbreviation => 'TX'},
    {:id => 44, :name => 'Utah', :abbreviation => 'UT'},
    {:id => 45, :name => 'Vermont', :abbreviation => 'VT'},
    {:id => 46, :name => 'Virginia', :abbreviation => 'VA'},
    {:id => 47, :name => 'Washington', :abbreviation => 'WA'},
    {:id => 48, :name => 'West Virginia', :abbreviation => 'WV'},
    {:id => 49, :name => 'Wisconsin', :abbreviation => 'WI'},
    {:id => 50, :name => 'Wyoming', :abbreviation => 'WY'}
]
states.each { |state| State.create state, :without_protection => true }

County.delete_all
County.create!({:id => 1, :name => 'Al 1', :state_id => 1}, :without_protection => true)
County.create!({:id => 2, :name => 'Al 2', :state_id => 1}, :without_protection => true)
County.create!({:id => 3, :name => 'Al 3', :state_id => 1}, :without_protection => true)
County.create!({:id => 4, :name => 'WY 1', :state_id => 50}, :without_protection => true)
County.create!({:id => 5, :name => 'WY 2', :state_id => 50}, :without_protection => true)
County.create!({:id => 6, :name => 'WY 3', :state_id => 50}, :without_protection => true)


Animal.delete_all
Animal.create!({:id => 1, :name => 'Beef cows'}, :without_protection => true)
Animal.create!({:id => 2, :name => 'Dairy cows'}, :without_protection => true)
Animal.create!({:id => 3, :name => 'Swine'}, :without_protection => true)
Animal.create!({:id => 4, :name => 'Horses'}, :without_protection => true)
Animal.create!({:id => 5, :name => 'Sheep'}, :without_protection => true)
Animal.create!({:id => 6, :name => 'Goats'}, :without_protection => true)
Animal.create!({:id => 7, :name => 'Veal'}, :without_protection => true)
Animal.create!({:id => 8, :name => 'Bison'}, :without_protection => true)
Animal.create!({:id => 9, :name => 'Llamas'}, :without_protection => true)
Animal.create!({:id => 10, :name => 'Alpacas'}, :without_protection => true)
Animal.create!({:id => 11, :name => 'Emus'}, :without_protection => true)

FieldType.delete_all
FieldType.create!({:id => 1, :name => 'Crop/pasture'}, :without_protection => true)
FieldType.create!({:id => 2, :name => 'Animal confinement'}, :without_protection => true)
FieldType.create!({:id => 3, :name => 'Non-managed land'}, :without_protection => true)

Irrigation.delete_all
Irrigation.create!({:id => 1, :name => 'Center Pivot Sprinkler'}, :without_protection => true)
Irrigation.create!({:id => 2, :name => 'Drip irrigation'}, :without_protection => true)
Irrigation.create!({:id => 3, :name => 'Surface Withdrawal'}, :without_protection => true)

SoilType.delete_all
SoilType.create!({:id => 1, :name => 'Soil type 1'}, :without_protection => true)
SoilType.create!({:id => 2, :name => 'Soil type 2'}, :without_protection => true)
SoilType.create!({:id => 3, :name => 'Soil type 3'}, :without_protection => true)

GeneratorType.delete_all
GeneratorType.create!({:id => 1, :name => 'Landowner/Producer'}, :without_protection => true)
GeneratorType.create!({:id => 2, :name => 'Agribusiness/Consultant'}, :without_protection => true)
GeneratorType.create!({:id => 3, :name => 'NGO/Nonprofit'}, :without_protection => true)
GeneratorType.create!({:id => 4, :name => 'Government'}, :without_protection => true)
GeneratorType.create!({:id => 5, :name => 'Soil Conservation District'}, :without_protection => true)
GeneratorType.create!({:id => 6, :name => 'Regulated Entity'}, :without_protection => true)
GeneratorType.create!({:id => 7, :name => 'Other'}, :without_protection => true)
