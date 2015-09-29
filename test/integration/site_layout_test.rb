require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
  	get root_path
  	assert_template 'static_pages/home'
  	assert_select 'a[href=?]', root_path, count: 2
  	assert_select 'a[href=?]', help_path
  	assert_select 'a[href=?]', about_path
  	assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', 'http://www.twitter.com', text: "Twitter"
    get signup_path
    assert_template 'users/new'
    assert_select "title", full_title("Sign up")#"Sign up|#{base_title}"
  	assert_select "div.container" #"faketwitter app"
  end
end
