class Users::RegistrationsController < Devise::RegistrationsController

  # redirect after sign-up

  def create
    if verify_recaptcha
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
      flash.delete :recaptcha_error
      render :new
    end
  end


  def after_inactive_sign_up_path_for(resource)
    test = super
    # redirect_to :action => 'create'
    # 'users/registrations#create'
    '/users/sign_in'
  end

end