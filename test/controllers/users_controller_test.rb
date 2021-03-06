require 'test_helper'

class UsersControllerTest < ActionController::TestCase
def  setup 
	@user = users(:michael)
	@other_user = users(:archer)
end
	


  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
  	get :edit, id: @user
    #get edit_user_path(@user) not work! why?
  	assert_redirected_to login_path
  end

  test "should redirect update when not logged in" do
  	patch :update, id: @user, user: { name: @user.name, email: @user.email }
  	assert_redirected_to login_path
  end

  test "should redirect edit when logged in as wrong user" do
  	log_in_as(@other_user)
    #get edit_user_path(@user)
  	get :edit, id: @user
  	assert_redirected_to root_path
  end

  test "should redirect update when logged in as wrong user"  do
  	log_in_as @other_user
  	patch :update, id:@user, user: { name: @user.name, email: @user.email }
  	assert_redirected_to root_path
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_path
  end

  test "should redirect destroy when not logged in" do 
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when logged in as non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do 
      delete :destroy, id: @user
    end
    assert_redirected_to root_path  
  end

  test "should not allow editing admin attrinute" do 
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @user, user: {password: "password",
                                    password_confirmation: "password",
                                    admin: true} 
    assert_not @other_user.reload.admin?
  end

  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_path
  end

  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_path
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    lana = users(:lana)
    archer = users(:archer)
    # people I am following
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    #my own 
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    #people I am not following
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)  
    end
  end
end
