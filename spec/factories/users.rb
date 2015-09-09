FactoryGirl.define do 
	factory :user do
		name "Wayne"
		sequence(:email) {|n| "wayne#{n}@wang.com"}
		password "foobar"
		admin true
		activated true
		#activated_at <%= Time.zone.now %>
	end
end