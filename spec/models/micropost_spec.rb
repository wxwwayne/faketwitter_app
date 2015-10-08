require 'rails_helper'

describe Micropost do
	before { @user = create(:user) }

	it "is valid with content and user_id" do
		micropost = build(:micropost, user: @user)
		expect(micropost).to be_valid
	end	
	it "is invalid with no content" do
		micropost = build(:invalid_micropost, user: @user)
		expect(micropost).not_to be_valid
	end
	it "is invalid with no user_id" do
		micropost = build(:micropost, user: nil)
		expect(micropost).not_to be_valid
	end
	describe "microposts order and dependence" do
		let(:old_post) do
			create(:micropost, created_at: 1.day.ago, user: @user)
		end
		let(:new_post) do
			create(:micropost, created_at: 1.minute.ago, user: @user)
		end 

		it "has the microposts in order" do
			expect(@user.microposts).to eq [new_post,old_post]
		end
		it "deletes all microposts if delete user" do
			id1 = old_post.id
			id2 = new_post.id
			@user.destroy
			expect(Micropost.find_by(id: id1)).to be_nil
			expect(Micropost.find_by(id: id2)).to be_nil
		end
	end
end