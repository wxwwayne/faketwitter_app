module MicropostMacros
	def create_a_micropost(micropost)
		click_link "Home"
		fill_in('micropost_content', with: micropost.content)
		click_button "Post"
	end
end