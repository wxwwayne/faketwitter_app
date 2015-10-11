require 'rails_helper'

feature 'User activated' do
	let(:viewer) { create(:user) }
	let(:activated_user) { create(:user) }

	scenario 'will be shown on users list', js: true do
		sign_in_with_remember(viewer)
		activated_user
		visit_index_page
		expect(page).to have_content activated_user.name
	end

	scenario 'will sign in and act just like a user', js: true do
		sign_in_with_remember(activated_user)
		expect(current_path).to eq user_path(activated_user)
		visit_home_page
		find(:xpath, "//textarea[@id='micropost_content']").set(
					"Activated user can make microposts!")
		click_button "Post"
		expect(page).to have_content "Activated user can make microposts!"
	end

end

feature 'User unactivated' do
	let(:viewer) { create(:user) }
	let(:unactivated_user) { create(:unactivated_user) }

	scenario 'will not be shown on users list but valid', js: true do
		sign_in_with_remember(viewer)
		unactivated_user
		visit_index_page
		expect(unactivated_user).to be_valid
		expect(page).not_to have_content unactivated_user.name
	end

	scenario 'will not log in and act like a normal user do', js: true do
		sign_in_with_remember(unactivated_user)
		expect(current_path).to eq root_path
		expect(page).to have_content "Account not activated!Check your email for the actvation link"
		#micropost textarea
		expect(page).not_to have_xpath("//textarea[@id='micropost_content']") 
	end
end

