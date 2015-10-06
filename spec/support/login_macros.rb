module LoginMacros
	def log_in_as(user)
		session[:user_id] = user.id 
	end

	def sign_up(user)
		visit root_path
		click_link 'Sign up now!'
     	fill_in 'Name', with: user.name
      	fill_in 'Email', with: user.email
      	fill_in 'Password', with: user.password
      	fill_in 'Confirmation', with: user.password
      	click_button 'Create my account'
	end

	def sign_in_with_remember(user)
		visit root_path
		click_link 'Log in'
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
end