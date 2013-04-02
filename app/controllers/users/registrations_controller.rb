class Users::RegistrationsController < Devise::RegistrationsController

  # redirect after sign-up

  def create
    # first validate form
    build_resource
    if !resource.valid?
      clean_up_passwords resource
      respond_with resource
    else
      if verify_recaptcha # validate re-captcha
        super
      else
        clean_up_passwords(resource)
        flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
        flash.delete :recaptcha_error
        render :new
      end
    end
  end


  def after_inactive_sign_up_path_for(resource)
    test = super
    # redirect_to :action => 'create'
    # 'users/registrations#create'
    '/users/sign_in'
  end

end