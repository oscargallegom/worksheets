class Users::RegistrationsController < Devise::RegistrationsController

  # redirect after sign-up


  def after_inactive_sign_up_path_for(resource)
    test = super
    # redirect_to :action => 'create'
    # 'users/registrations#create'
    '/users/sign_in'
  end

end