require 'rails_helper'

feature 'User create' do
	scenario "adds a new user", js: true do
      user = build(:user)
      mail = UserMailer.account_activation(user)
    	expect{sign_up(user)}.to change(User, :count).by(1)
      check_account_activation_email(user)
    	expect(current_path).to eq root_path
    	expect(page).to have_content 'Please check your email to activate your account.'
    end

    scenario "fail to add a new user", js: true do 
      invalid_user = build(:invalid_user)
    	expect{sign_up(invalid_user)}.to change(User, :count).by(0)
    	expect(current_path).to eq users_path
    end

    scenario "delete a user", js: true do
      admin = create(:admin)
      user = create(:user)
      sign_in_without_remember(admin)
      click_link 'Users'
      expect{click_link 'delete'}.to change(User, :count).by(-1)
      expect(page).to have_content "User deleted, Admin #{admin.name}"
    end
end