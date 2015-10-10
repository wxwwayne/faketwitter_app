FactoryGirl.define do
	factory :relationship do
		follower nil
		followed nil
		created_at Time.zone.now
	end
end
