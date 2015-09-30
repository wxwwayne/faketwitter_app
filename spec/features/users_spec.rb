require 'rails_helper'

feature 'User create' do
	scenario "adds a new user", js: true do

		visit root_path
    	expect{
      		click_link 'Sign up now!'
      		fill_in 'Name', with: 'Wayne'
      		fill_in 'Email', with: 'newuser@example.com'
      		fill_in 'Password', with: 'secret123'
      		fill_in 'Confirmation', with: 'secret123'
      		click_button 'Create my account'
    	}.to change(User, :count).by(1)
    	expect(current_path).to eq root_path
    	expect(page).to have_content 'Please check your email to activate your account.'
    end

    scenario "fail to add a new user", js: true do 
    	visit root_path
    	expect{
      		click_link 'Sign up now!'
      		fill_in 'Name', with: ''
      		fill_in 'Email', with: 'newuser@invalid'
      		fill_in 'Password', with: 'foo'
      		fill_in 'Confirmation', with: 'bar'
      		click_button 'Create my account'
    	}.to change(User, :count).by(0)
    	expect(current_path).to eq users_path
    end
end