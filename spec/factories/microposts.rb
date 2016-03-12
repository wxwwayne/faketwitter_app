FactoryGirl.define do
	factory :micropost do
		content Faker::Lorem.sentence(2)
		created_at Time.zone.now
		user

		factory :invalid_micropost do
			content nil
		end
	end
end
