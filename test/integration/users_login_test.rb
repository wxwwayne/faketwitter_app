require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
def setup
	@user = users(:michael)
end

  
 test "login with invalid information" do
  get login_path
  assert_template 'sessions/new'
  post login_path, session: { email: "", password: "" }
  assert_template 'sessions/new'
  #assert_redirected_to login_path
  assert_not flash.empty?
  get root_path
  assert flash.empty?
 end

 test "login with valid information and then logout" do
 	get login_path
 	post_via_redirect login_path, session: { email: @user.email, password: 'password'}
 	assert_template 'users/show'
 	assert_select "a[href=?]", login_path, count: 0
 	assert_select "a[href=?]", logout_path
 	assert_select "a[href=?]", user_path(@user)
 	assert is_logged_in?
 	delete logout_path
 	#delete_via_redirect logout_path
 	assert_not is_logged_in?
 	assert_redirected_to root_path
 	delete logout_path
 	follow_redirect!
 	#assert_template '/'
 	assert_select "a[href=?]", login_path
 	assert_select "a[href=?]", logout_path, count: 0
 	assert_select "a[hreg=?]", user_path(@user), count: 0
 end
 test "login with remembering" do
 	log_in_as(@user)
 	assert_equal assigns[:user].remember_token, cookies['remember_token'] 
 	#assert_not_nil cookies['remember_token']
 	#assert_not_nil cookies[:remember_token] can not be recognized? why?
 end
 test "login without remembering" do
 	log_in_as(@user,remember_me: '0')
 	assert_nil assigns[:user].remember_digest
 end

end
