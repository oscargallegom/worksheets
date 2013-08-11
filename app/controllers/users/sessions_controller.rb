class Users::SessionsController < Devise::SessionsController
  # layout "login"

  def after_sign_in_path_for(resource)

    # used to show some debug information
    session[:debug] = current_user.is_debug_mode

    params[:next].blank? ? farms_path : params[:next]

  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end