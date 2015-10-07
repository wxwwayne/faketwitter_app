module PageMacros
	def visit_profile_page
		find('[class=user]').click
	end

	def visit_home_page
		click_link "Home"
	end

	def visit_index_page
		click_link "Users"
	end

end