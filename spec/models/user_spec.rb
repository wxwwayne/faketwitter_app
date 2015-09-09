require 'rails_helper'

describe User do
	before :each do 
		@user = User.new(
			name: 'Wayne',
			email:'wayne@wang.com',
			password: 'foobar')
	end
	it "is valid with name, password and email" do
		expect(@user).to be_valid
	end
	it "is invalid without name" do
		@user.name = nil 
		expect(@user).not_to be_valid
		expect(@user.errors[:name]).to include("can't be blank")
	end
	it "is invalid with duplicated email" do
		User.create(
			name: "Wayne",
			email: 'wayne@wang.com',
			password:'foobar')
		expect(@user).not_to be_valid
		expect(@user.errors[:email]).to include("has already been taken")
	end

	it "is invalid with illigal email address" do
		illegal_addresses = %w[user@example,com user_at_foo.org user.name@example.
                               foo@bar_baz.com foo@bar+baz.com]
        illegal_addresses.each do |illegal_address|
        	@user.email = illegal_address 
        	expect(@user).not_to be_valid, "#{illegal_address.inspect} is not a valid address"
        end
    end
        		
end