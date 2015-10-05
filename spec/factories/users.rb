FactoryGirl.define do 
	factory :user do
		name { Faker::Name.name }		
		#sequence(:email) {|n| "wayne#{n}@wang.com"}
		email { Faker::Internet.email }
		password "foobar"
		admin false
		activated true
		activated_at Time.zone.now

		factory :invalid_user do 
			email nil
		end

		factory :admin do
			admin true
		end

		factory :wayne do 
			name "Wayne Wang"
			email "wayne@wang.com"
			admin true
			activated_at 2.months.ago
		end
		# after(:build) do |user|
		# 	user.microposts << FactoryGirl.build(:micropost,
		# 				content: Faker::Lorem.sentence(5),
		# 				created_at: Time.zone.now,
		# 				user: user)
		# end
	end
end