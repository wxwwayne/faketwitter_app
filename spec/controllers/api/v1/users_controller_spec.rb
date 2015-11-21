require 'rails_helper'

describe Api::V1::UsersController do
  describe "GET #show" do
    before :each do
      @user = create(:user)
      request.headers['Authorization'] = "Token token=\"#{@user.authentication_token}\", email=\"#{@user.email}\""
      # header('Authorization', "Token token=\"#{user.authentication_token}\", email=\"#{user.email}\"")
      get :show, id: @user
    end

    it "returns a hash of user information" do
      user_response = json_response[:user]
      expect(user_response[:email]).to eq(@user.email)
    end

    it "has micropost ids as embeded object " do
      user_response = json_response[:user]
      expect(user_response[:micropost_ids]).to eq []
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before :each do
      4.times { create(:user) }
      get :index, id: {le: 2}
    end

    it "returns users list from database" do
      users_response = json_response[:users]
      expect(users_response.count).to eq 4
    end

    it { should respond_with 200 }
  end
end
