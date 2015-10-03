require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
  	ActionMailer::Base.deliveries.clear
  	@user = users(:michael)
  end

  test "password reset" do
  	get new_password_reset_path
  	assert_template 'password_resets/new'
    #email not match registered email
    post password_resets_path, password_reset: { email: "invalid" }
    assert_template 'password_resets/new'
    assert_not flash.empty?
    assert @user.reset_digest.nil?
    #valid email
  	post password_resets_path, password_reset: { email: @user.email }
  	assert_not @user.reload.reset_digest.nil?
  	assert_equal 1, ActionMailer::Base.deliveries.size
  	assert_not flash.empty?
  	assert_redirected_to root_path
  	#password reset form
  	user = assigns(:user)# to get the @user in create controller!!
  	#wrong email address in link
  	get edit_password_reset_path(user.reset_token, email: "invalid")
  	assert_redirected_to root_path
  	#user not activated
  	user.toggle!(:activated)
  	get edit_password_reset_path(user.reset_token, email: user.email)
  	assert_redirected_to root_path
  	user.toggle!(:activated)
  	#wrong token
  	get edit_password_reset_path("wrong token", email: user.email)
  	assert_redirected_to root_path
  	#rignt roken and right email
  	get edit_password_reset_path(user.reset_token, email: user.email)
  	assert_template 'password_resets/edit'
    #find the hidden tag
  	assert_select "input[name=email][type=hidden][value=?]", user.email
  	#password and confirmation don't match
  	patch password_reset_path(user.reset_token),
  						email: user.email,
  						user: {password: "foobar",
  								password_confirmation: "foobaz"}
  	assert_select 'div#error_explanation'
  	#password empty
  	patch password_reset_path(user.reset_token),
  						email: user.email,
  						user: { password: " ",
  								password_confirmation: "whatever" }
  	assert_not flash.empty?
  	assert_template 'password_resets/edit'
  	#everything is right
  	patch password_reset_path(user.reset_token),
  							email: user.email,
  							user: {password: "foobar",
  									password_confirmation: "foobar"}
  	assert is_logged_in?
  	assert_not flash.empty?
  	assert_redirected_to user
  end
end
