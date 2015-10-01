require 'rails_helper'

feature 'User Login Logout' do
	scenario "fail to log in user", js: true do
		visit root_path
		click_link 'Log in'
		fill_in 'Email', with: 'email@invalid.com'
		fill_in 'Password', with: 'foobar'
		check "Remember me"
		click_button 'Log in'
		expect(current_path).to eq login_path
		expect(page).to have_content 'Invalid email/password combination'
	end

	scenario "Log in user", js: true do
		user = FactoryGirl.create(:user)
		visit root_path
		click_link 'Log in'
		fill_in 'Email', with: 'wayne1@wang.com'
		fill_in 'Password', with: 'foobar'
		check "Remember me"
		click_button 'Log in'
		expect(current_path).to eq user_path(user)
		expect(page).to have_content 'Users'
		
	end
end
		