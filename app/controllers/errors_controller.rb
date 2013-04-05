class ErrorsController < ApplicationController

  def not_found
  end

  def not_authorized
    # if user not signed in, then go to login page
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
