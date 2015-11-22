FactoryGirl.define do
	factory :user do
		name { Faker::Name.name }
		email { Faker::Internet.email }
		password "foobar"
		admin false
		activated true
		activated_at Time.zone.now

		factory :invalid_user do
			email "invalid_user"
		end

		factory :admin do
			admin true
		end

		factory :unactivated_user do
			activated false
		end

		factory :wayne do
			name "Wayne Wang"
			email "wayne@wang.com"
			admin true
			activated_at 2.months.ago
		end
	end
end
