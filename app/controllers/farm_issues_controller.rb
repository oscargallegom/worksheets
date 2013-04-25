class FarmIssuesController < ApplicationController

  add_breadcrumb 'Home', '/'

  def new
    add_breadcrumb params[:farm_name], farm_path(params[:farm_id])
    add_breadcrumb 'Email issue'

    @farm_issue = FarmIssue.new
    @farm_issue.farm_id = params[:farm_id]
    @farm_issue.farm_name = params[:farm_name]
  end

  def create

    @farm_issue = FarmIssue.new(params[:farm_issue])

    # make sure that the user is allowed to manage farm
    @farm = Farm.find(@farm_issue.farm_id)
    authorize! :manage, @farm

    if @farm_issue.valid?
      UserMailer.farm_issue_email(current_user, @farm_issue).deliver
      redirect_to(root_path, :notice => "Message was successfully sent.")
    else
      add_breadcrumb @farm_issue.farm_name, farm_path(@farm_issue.farm_id)
      add_breadcrumb 'Email issue'
      flash.now.alert = "Please enter a message."
      render :new
    end
  end


end
