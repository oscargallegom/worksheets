#######################################################
# Global variables used in the application
#######################################################

case ENV['RAILS_ENV']
  when "development"
    ADMIN_EMAIL = 'oleblond@gmail.com'
  when "staging"
  when "production"
    ADMIN_EMAIL = 'oleblond@gmail.com'
end