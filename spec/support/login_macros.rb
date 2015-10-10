module LoginMacros
	#for controller spec
	def log_in_as(user)
		session[:user_id] = user.id 
	end

	def fill_in_form_with(profile)
		fill_in 'Name', with: profile.name
		fill_in 'Email', with: profile.email
		fill_in 'Password', with: profile.password
		fill_in 'Confirmation', with: profile.password
	end

	def sign_up(user)
		visit root_path
		click_sign_up
		fill_in_form_with(user)
      	click_button 'Create my account'
	end

	def sign_in_with_remember(user)
		visit root_path
		click_log_in
		fill_in 'Email', with: user.email
		fill_in 'Password', with: user.password
		check "Remember me"
		click_button 'Log in'
	end

	def sign_in_without_remember(user)
		visit root_path
		click_link 'Log in'
		fill_in 'Email', with: user.email
		fill_in 'Password', with: user.password
		click_button 'Log in'
	end

	def update_profile(profile)
		visit_setting_page
		fill_in_form_with(profile)
		click_button 'Save change'
	end
end