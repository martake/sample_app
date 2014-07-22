class UserMailer < ActionMailer::Base
  default :from => "info@railstutorial.com"
  
  def followup_notification(followed_user, follower_user)
    @followed_user = followed_user
    @follower_user = follower_user
    attachments["rails.png"] = File.read("#{Rails.root}/app/assets/images/rails.png")
    mail(:to => "#{followed_user.name} <#{followed_user.email}>", :subject => "#{follower_user.name} is Your Follower")
  end
end