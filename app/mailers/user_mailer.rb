class UserMailer < ActionMailer::Base
  default from: 'cbnttmanager@gmail.com'
  def welcome_email(user)
    @user = user
    @url = 'http://cbntt.org'
    mail(:to => user.email, :subject => "Welcome to NutrientNet")
  end

  def project_issue_email(user, project_issue)
    #admin_user = User.where(:id => 1).first # TODO: put admin email in environment variable
    @user = user
    @project_issue = project_issue
    @host = root_path.gsub(/\/$/, '').gsub("http://", "")
    mail(:to => 'cbnttmanager@gmail.com', :subject => "Issue with project")
  end

end
