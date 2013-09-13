class UserMailer < ActionMailer::Base
  default from: ENV['email_login']

  def welcome_email(user)
    @user = user
    @url = root_url
    mail(:to => user.email, :subject => "Welcome to NutrientNet") # TODO: replace with user.email instead of hard-coded value
  end

  def project_issue_email(user, project_issue)
    #admin_user = User.where(:id => 1).first # TODO: put admin email in environment variable
    @user = user
    @project_issue = project_issue
    @url = root_url
    mail(:to => ENV['email_login'], :subject => "Issue with project")
  end

end
