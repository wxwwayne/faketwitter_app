module ApplicationHelper
	def full_title(page_title)
		base_title = "Faketwitter App"
		if page_title.empty?
			base_title
		else
			page_title + "|" + base_title
		end
	end

	# 返回指定用户的Gravatar
	def gravatar_for(user, options = { size: 80 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end

	#It is originally located in users_helper.rb. But I put it here for 
	#easy maintance!
	#默认情况下,所有辅助方法文件中定义的方法都自动在任意视图中可用!
end
