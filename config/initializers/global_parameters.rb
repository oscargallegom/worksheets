#######################################################
# Global variables used in the application
#######################################################

# URL to the mapping application
# URL_MAP = 'http://ims.missouri.edu/marylandNN/MultiStates.aspx'
URL_MAP = 'http://ims.missouri.edu/marylandNN/Default2.aspx'
URL_NTT = 'http://nn.tarleton.edu/nnmultiplestates/NNRestService.ashx'

case Rails.env
  when "development"
    ADMIN_EMAIL = 'oleblond@gmail.com'
  when "staging"
  when "production"
    ADMIN_EMAIL = 'oleblond@gmail.com'
end