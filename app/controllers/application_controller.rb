class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    # if user not signed in, then go to login page
    if !user_signed_in?
      redirect_to new_user_session_path(:next => request.fullpath)
    elsif redirect_to '/401'
    end

  end


  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:alert] = exception.message
    # TODO: remove exception message in production (security) - also should be 404, not 401 (just here to display messages in dev)
    redirect_to '/401'
  end
end
