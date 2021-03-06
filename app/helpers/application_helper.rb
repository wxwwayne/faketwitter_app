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
	def gravatar_for(user, options = { size: 50 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end

	#It is originally located in users_helper.rb. But I put it here for 
	#easy maintance!
	#默认情况下,所有辅助方法文件中定义的方法都自动在任意视图中可用!
	#login certain user
	def log_in(user)
		session[:user_id] = user.id
	end

	#to remember user in lasting session
	def remember(user)
		user.remember #将remember_digest存入数据库
		#将remember_token 和id 存入cookie
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def current_user?(user)
		user == current_user
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end
	#return current user(if exists)
	def current_user
		if (session[:user_id])
			@current_user ||= User.find_by(id: session[:user_id])
		elsif (cookies.signed[:user_id])
			user = User.find_by(id: cookies.signed[:user_id])
			if user && user.authenticated?(:remember, cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end	
	

	def logged_in?
		!current_user.nil?
		#!session[:user_id].nil?
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

  	def redirect_back_or(default)
    	redirect_to(session[:forwarding_url] || default)
    	session.delete(:forwarding_url)
  	end

  	def store_location
    	session[:forwarding_url] = request.url if request.get?
  	end
end
