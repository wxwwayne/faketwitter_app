FactoryGirl.define do 
	factory :user do
		name { Faker::Name.name }		
		#sequence(:email) {|n| "wayne#{n}@wang.com"}
		email { Faker::Internet.email }
		password "foobar"
		admin false
		activated true
		activated_at Time.zone.now
	end
end