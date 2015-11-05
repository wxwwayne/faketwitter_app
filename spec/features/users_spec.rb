require 'rails_helper'

feature 'Users management' do
  scenario "will add a new user", js: true do
    user = build(:user)
    expect{ sign_up(user) }.to change(User, :count).by(1)
    check_account_activation_email(user)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Please check your email to activate your account.'
  end

  scenario "will fail to add a new user", js: true do
    invalid_user = build(:invalid_user)
    expect{ sign_up(invalid_user) }.to change(User, :count).by(0)
    expect(current_path).to eq users_path
  end

  scenario "will update user profile", js: true do
    user = create(:user)
    new_profile = build(:user)
    sign_in_without_remember(user)
    update_profile(new_profile)
    expect(page).to have_content "Profile updated"
    expect(page).to have_content new_profile.name
  end

  scenario "will delete a user", js: true do
    admin = create(:admin)
    user = create(:user)
    sign_in_without_remember(admin)
    click_link 'Users'
    expect{ click_link 'delete' }.to change(User, :count).by(-1)
    expect(page).to have_content "User deleted, Admin #{admin.name}"
  end
end
