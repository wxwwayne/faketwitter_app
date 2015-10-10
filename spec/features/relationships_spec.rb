require 'rails_helper'

feature 'Relationship' do
	let(:wayne) { create(:user, name: 'Wayne') }
	let(:lizz) { create(:user, name: 'Lizz') }
	let(:wayne_post) { create(:micropost, user: wayne) }
	let(:lizz_post) { create(:micropost, user: lizz) }
	
	scenario 'will follow other user', js: true do
		sign_in_without_remember(wayne)
		find_one_to_follow(lizz)
		expect(page).to have_button "Follow"
		follow_show_different_stat(wayne)
		find_following_post_in_feed(lizz_post)
	end

	scenario 'will unfollow other user', js: true do
		sign_in_without_remember(wayne)
		find_one_to_follow(lizz)
		click_button "Follow"
		expect(page).to have_button "Unfollow"
		unfollow_show_different_stat(wayne)
		find_no_post_of_unfollow_in_feed(lizz_post)
	end
end