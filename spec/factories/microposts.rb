FactoryGirl.define do
	factory :micropost do
		sequence(:content) {|n| "This is the No.#{n} micropost"}
		#created_at 10.minutes.ago 
		#user "Wayne"
		#user_id 
	end
end