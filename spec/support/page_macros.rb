module PageMacros
	def visit_profile_page
		find('.dropdown-toggle').click
		find(:xpath, "//ul[@class='dropdown-menu']/li[1]/a").click
	end

	def visit_home_page
		find(:xpath, "//ul[@class='nav navbar-nav navbar-right']/li[1]/a").click
	end

	def visit_index_page
		find(:xpath, "//ul[@class='nav navbar-nav navbar-right']/li[3]/a").click
	end

	def visit_setting_page
		find('.dropdown-toggle').click
		find(:xpath, "//ul[@class='dropdown-menu']/li[2]/a").click
	end

	def log_out
		find('.dropdown-toggle').click
		find(:xpath,"//ul[@class='dropdown-menu']/li[4]/a").click
	end

end