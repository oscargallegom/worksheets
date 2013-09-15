class ProjectIssuesController < ApplicationController

  add_breadcrumb 'Home', :farms_path

  def new
    add_breadcrumb params[:farm_name], farm_path(params[:farm_id])
    add_breadcrumb 'Email issue'

    @project_issue = ProjectIssue.new
    @project_issue.farm_id = params[:farm_id]
    @project_issue.farm_name = params[:farm_name]
  end

  def create

    @project_issue = ProjectIssue.new(params[:project_issue])

    # make sure that the user is allowed to manage farm
    @farm = Farm.find(@project_issue.farm_id)
    authorize! :manage, @farm

    if @project_issue.valid?
      UserMailer.project_issue_email(current_user, @project_issue).deliver
      redirect_to(farms_path, :notice => "Your message was successfully sent.")
    else
      add_breadcrumb @project_issue.farm_name, farm_path(@project_issue.farm_id)
      add_breadcrumb 'Email issue'
      flash.now.alert = "Please enter a message."
      render :new
    end
  end


end
