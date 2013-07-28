class UserMailer < ActionMailer::Base
  default from: ADMIN_EMAIL

  def welcome_email(user)
    @user = user
    @url = root_url
    mail(:to => 'oleblond@gmail.com', :subject => "Welcome to NutrientNet") # TODO: replace with user.email instead of hard-coded value
  end

  def project_issue_email(user, project_issue)
    #admin_user = User.where(:id => 1).first # TODO: put admin email in environment variable
    @user = user
    @project_issue = project_issue
    @url = root_url
    mail(:to => ADMIN_EMAIL, :subject => "Issue with project")
  end

end
