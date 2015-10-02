require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:michael)
  end

  test "unsuccessful edit" do
  log_in_as(@user)
	get edit_user_path(@user)
	patch user_path(@user), user: {name: '',
								email: 'foo@invalid',
								password: 'foo',
								password_confirmation: 'bar'}
	assert_template 'users/edit'	  	
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
  	#get edit_user_path(@user)
  	name = "Foo Bar"
  	email = "foo@bar.com"
  	patch user_path(@user), user:{ name: name,
  								email: email,
  								password: "",
  								password_confirmation: ""}
  	assert_redirected_to @user
  	assert_not flash.empty?
  	@user.reload
  	assert_equal @user.name, name
  	assert_equal @user.email, email
  end

  test "friendly forwarding will work only once" do 
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    log_out(@user)
    log_in_as(@user)
    assert_redirected_to @user
  end
end
