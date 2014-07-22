class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    # message.to = "example@railstutorial.com"
    message.to = "mar.takeuchi@gmail.com"
  end
end