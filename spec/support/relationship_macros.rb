module RelationshipMacros
	def follow_show_different_stat(user)
		click_button "Follow"
		visit_profile_page
		expect(user.following.count).to eq 1
	end

	def find_following_post_in_feed(micropost)
		micropost
		visit_home_page
		expect(page).to have_content micropost.content
	end

	def find_one_to_follow(user)
		user
		visit_index_page
		click_link user.name
	end

	def unfollow_show_different_stat(user)
		click_button "Unfollow"
		expect(user.following.count).to eq 0
	end

	def find_no_post_of_unfollow_in_feed(micropost)
		micropost
		visit_home_page
		expect(page).not_to have_content micropost.content
	end
end