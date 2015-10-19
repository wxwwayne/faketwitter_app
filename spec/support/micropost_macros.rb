module MicropostMacros
	def create_a_micropost(micropost)
		click_link "Home"
		fill_in('micropost_content', with: micropost.content)
		click_button "Post"
	end

	def delete_the_micropost	
		visit_profile_page	
		click_link("delete")
		page.driver.browser.switch_to.alert.accept
	end
end