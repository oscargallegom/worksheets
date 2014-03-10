class ErrorsController < ApplicationController

  def not_found
    flash.now[:error] = 'Page not found.'
  end

  def not_authorized
    flash.now[:error] = 'You are not authorized to access this page.'
  end

  def map_down
    flash.now[:error] = 'The mapping system did not return valid data.'
  end

  #def server_error
  #  test=0
  #end
end
