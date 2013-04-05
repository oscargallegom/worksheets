class Users::RegistrationsController < Devise::RegistrationsController

  add_breadcrumb 'Home', :projects_path
  # redirect after sign-up

  def new
    add_breadcrumb 'New account'
    super
  end

  def edit
    add_breadcrumb 'Update account'
    super
  end

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

  # update user account
  def update
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end


  def after_inactive_sign_up_path_for(resource)
    # redirect_to :action => 'create'
    # 'users/registrations#create'
    '/users/sign_in'
  end

end