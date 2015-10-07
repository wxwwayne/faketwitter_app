require 'rails_helper'

feature "Microposts management" do 
	let(:user) { create(:user) }
	let(:other_user) {create(:user)}
	let(:micropost) {build(:micropost, user: user)}
	before {sign_in_without_remember(user)}

	scenario "make a new micropost", js: true do
		expect{ create_a_micropost(micropost) }.to change(Micropost, :count).by(1)
		expect(page).to have_content "Micropost created!"
		expect(page).to have_content micropost.content
		expect(current_path).to eq root_path
	end

	scenario "delete a micropost", js: true do
		create_a_micropost(micropost)
		delete_the_micropost_in_profile_page 
		expect(page).not_to have_content micropost.content
		expect(page).to have_content "Micropost deleted!"
	end

	scenario "can view but not delete others' micropost", js: true do
		create_a_micropost(micropost)
		log_out
		sign_in_without_remember(other_user)
		visit_home_page
		#click_link "Home"
		#expect(page).to have_content micropost.content
		expect(page).not_to have_link "delete"
	end
end