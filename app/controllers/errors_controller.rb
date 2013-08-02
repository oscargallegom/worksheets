class ErrorsController < ApplicationController

  def not_found
    flash.now[:error] = 'Page not found.'
  end

  def not_authorized
    flash.now[:error] = 'You are not authorized to access this page.'
  end

  #def server_error
  #  test=0
  #end
end
