class ApplicationMailer < ActionMailer::Base
  default from: "noreply@faketwitter.com"
  layout 'mailer'
end
