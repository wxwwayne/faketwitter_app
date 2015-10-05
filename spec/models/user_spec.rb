require 'rails_helper'

describe User do
	it "is valid with name, password and email" do
		expect(build(:user)).to be_valid
	end
	it "is invalid without name" do
		user = build(:wayne, name: nil) 
		expect(user).not_to be_valid
		expect(user.errors[:name]).to include("can't be blank")
	end
	it "is invalid with duplicated email" do
		create(:user, email: "wayne@wang.com")
		user = build(:user, email: "wayne@wang.com")
		expect(user).not_to be_valid
		expect(user.errors[:email]).to include("has already been taken")
	end
	it "is invalid with too-long email" do
		user = build(:user, email: "a" * 244 + "@example.com")
		expect(user).not_to be_valid
		expect(user.errors.full_messages).to include("Email is too long (maximum is 255 characters)")
	end
	it "is invalid with illigal email address" do
		illegal_addresses = %w[user@example,com user_at_foo.org user.name@example.
                               foo@bar_baz.com foo@bar+baz.com]
        illegal_addresses.each do |illegal_address|
        	user = build(:user, email: illegal_address)
        	expect(user).not_to be_valid, "#{illegal_address.inspect} is not a valid address"
        end
    end
        		
end