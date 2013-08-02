class Users::SessionsController < Devise::SessionsController
  # layout "login"

  def after_sign_in_path_for(resource)

    # TODO: to be removed
    session[:debug] = (!params[:user].nil? && params[:user][:username].index('debug')!=nil) ? true : false

    #params[:next]. || farms_path
    params[:next].blank? ? farms_path : params[:next]

  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end