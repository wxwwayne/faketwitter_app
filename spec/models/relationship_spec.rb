require 'rails_helper'

describe Relationship do
	let(:followed) { create(:user) }
	let(:follower) { create(:user) }

	describe "relationship attributes" do
		
		it "is valid with followed_id and follower_id" do
			relationship = build(:relationship, 
								follower: follower,
				 				followed: followed)
			expect(relationship).to be_valid
		end

		it "is invalid without followed_id" do
			relationship = build(:relationship, 
								follower: follower)
			expect(relationship).not_to be_valid
		end

		it "is invalid without follower_id" do
			relationship = build(:relationship, 
								followed: followed)
			expect(relationship).not_to be_valid
		end
	end

	describe "dependency" do
		it "is deleted if follower is deleted" do
			relationship = build(:relationship, 
								follower: follower,
				 				followed: followed)
			follower.destroy
			expect(Relationship.find_by(id: relationship.id)).to be_nil
		end

		it "is deleted if followed is deleted" do
			relationship = build(:relationship, 
								follower: follower,
				 				followed: followed)
			followed.destroy
			expect(Relationship.find_by(id: relationship.id)).to be_nil
		end
	end
end