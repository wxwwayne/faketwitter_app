require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:michael)
  end
  test "microposts interface" do
  	log_in_as(@user)
  	#assert_template 'users/show'
  	get root_path
  	assert_select 'div.pagination'
  	#failure post
  	assert_no_difference "Micropost.count" do
  		post microposts_path, micropost: { content: "" }
  	end
  	assert_select 'div#error_explanation'
  	#successful post
  	assert_difference 'Micropost.count', 1 do
  		post microposts_path, micropost: {content: "Hello"}
  	end
  	assert_redirected_to root_path
  	follow_redirect!
  	assert_not flash.empty?
  	assert_match "Hello", response.body
  	#delete a post
  	assert_select 'a', text:"delete"
  	first_micropost = @user.microposts.paginate(page: 1).first
  	assert_difference 'Micropost.count', -1 do
  		delete micropost_path(first_micropost)
  	end
  	#view other user's profile
  	get user_path(users(:archer))
  	assert_select 'a', text: 'delete', count: 0
  end
end
