module MailerMacros 
	def last_email
		ActionMailer::Base.deliveries.last 
	end

	def check_account_activation_email(user)
		expect(last_email.from).to eq ["noreply@faketwitter.com"]
      	expect(last_email.to).to eq [user.email]
      	expect(last_email).to have_subject "Account activation"
      	expect(last_email).to have_content user.activation_token
	end

	def reset_email 
		ActionMailer::Base.deliveries = []
	end
end
