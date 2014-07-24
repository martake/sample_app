ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :domain               => "heroku.com",
  :user_name            => ENV['SENDGRID_USERNAME'],
  :password             => ENV['SENDGRID_PASSWORD'],
  :authentication       => "plain"
}

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options[:host] = Rails.env.development? ? "localhost:3000" : "https://enigmatic-sands-1609.herokuapp.com"
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
