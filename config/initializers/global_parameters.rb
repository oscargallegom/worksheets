#######################################################
# Global variables used in the application
#######################################################


# URL to the mapping application
if Rails.application.config.which_map == "ntt"
	URL_MAP = ' http://nn.tarleton.edu/GoogleMapPost/Default.aspx'
else
	URL_MAP = ' http://projects.cares.missouri.edu/wri-nutrientnet/multistates.aspx'
end


URL_NTT = 'http://nn.tarleton.edu/nnmultiplestates/NNRestService.ashx'


#### This is the test NTT ####
#URL_NTT = 'http://nn.tarleton.edu/nn0806/NNRestService.ashx'

#case Rails.env
#  when "development"
#    ADMIN_EMAIL = 'oleblond@gmail.com'
#  when "staging"
#  when "production"
#    ADMIN_EMAIL = 'oleblond@gmail.com'
#end