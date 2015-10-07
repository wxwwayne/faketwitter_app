require 'rails_helper'

feature 'User Login Logout' do
	scenario "fail to log in user", js: true do
		user = create(:user)
		visit root_path
		click_link 'Log in'
		fill_in 'Email', with: user.email
		fill_in 'Password', with: "invalid"
		check "Remember me"
		click_button 'Log in'
		expect(current_path).to eq login_path
		expect(page).to have_content 'Invalid email/password combination'
		click_link 'Home'
		expect(page).not_to have_content 'Invalid email/password combination'
	end

	scenario "log in user", js: true do
		user = create(:user)
		sign_in_with_remember(user)
		expect(current_path).to eq user_path(user)
		expect(page).to have_content user.name	
	end

	scenario "log out user", js: true do
		user = create(:user)
		sign_in_with_remember(user)
		expect(current_path).to eq user_path(user)
		log_out
		expect(current_path).to eq root_path
		expect(page).to have_content "Log in"
		#expect(session[:user_id]).to eq nil
	end

end
		