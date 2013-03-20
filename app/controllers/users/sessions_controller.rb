class Users::SessionsController < Devise::SessionsController
  # layout "login"

  def after_sign_in_path_for(resource)
    projects_path
  end
end