class ProjectIssuesController < ApplicationController

  add_breadcrumb 'Home', '/'

  def new
    add_breadcrumb params[:project_name], project_path(params[:project_id])
    add_breadcrumb 'Email issue'

    @project_issue = ProjectIssue.new
    @project_issue.project_id = params[:project_id]
    @project_issue.project_name = params[:project_name]
  end

  def create

    @project_issue = ProjectIssue.new(params[:project_issue])

    # make sure that the user is allowed to manage project
    @project = Project.find(@project_issue.project_id)
    authorize! :manage, @project

    if @project_issue.valid?
      UserMailer.project_issue_email(current_user, @project_issue).deliver
      redirect_to(root_path, :notice => "Message was successfully sent.")
    else
      add_breadcrumb @project_issue.project_name, project_path(@project_issue.project_id)
      add_breadcrumb 'Email issue'
      flash.now.alert = "Please enter a message."
      render :new
    end
  end


end
