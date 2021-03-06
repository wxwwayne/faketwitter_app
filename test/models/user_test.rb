require 'test_helper'

class UserTest < ActiveSupport::TestCase
  #password and password_confirmation are virtual attributes which
  #are from the has_secure_password method in User model.
  #They are not in database but in model!
  def setup
  	@user= User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name= "   "
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = "  "
  	assert_not @user.valid?
  end

  test "name should not be too long" do 
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
  						first.last@foo.jp alice_bob@baz.cn]
  	valid_addresses.each do |valid_address|
  		@user.email = valid_address
  		assert @user.valid?, "#{valid_address.inspect} should be valid"
  	end
  end

  test "email validation should reject invalid addesses" do 
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
    	@user.email = invalid_address
    	assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
  	@user.save
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	assert_not duplicate_user.valid?
  end

  test "password should have a minimum length" do 
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "emails should be saved in low case" do
    mixed_case_email = "Wayne@Wang.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal @user.reload.email, "wayne@wang.com"
  end

  test "associated microposts shoud be destroyed" do
    @user.save
    @user.microposts.create!(content: "Hello")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followed_by?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
    assert_not archer.followed_by?(michael)
  end

end 
  

