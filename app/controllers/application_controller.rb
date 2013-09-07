class ApplicationController < ActionController::Base
  protect_from_forgery

  #if Rails.env.production?
    unless Rails.application.config.consider_all_requests_local
      rescue_from Exception, :with => :render_500
      rescue_from CanCan::AccessDenied, with: :render_401
      rescue_from ActiveRecord::RecordNotFound,
                  ActionController::UnknownController,
                  ActionController::MethodNotAllowed do |exception|
        render_500(exception)
      end
    end
  #end


  def render_500(exception)
    flash.now[:error] = 'An error has occurred.'
    flash.now[:debug] = exception.message
    respond_to do |format|
      format.html { render 'errors/server_error', status: 500 }
    end
  end

  # not authorized
  def render_401(exception)
    flash.now[:error] = exception.message
    if !user_signed_in?
      redirect_to new_user_session_path(:next => request.fullpath)
    elsif redirect_to '/401'
    end
  end


end
