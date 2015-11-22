require 'rails_helper'

describe Api::V1::UsersController do
  describe "GET #show" do
    before :each do
      @user = create(:user)
      request.headers['Authorization'] = "Token token=\"#{@user.authentication_token}\", email=\"#{@user.email}\""
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

  describe "PATCH #update" do
    context "user updates itself with authentication_token" do
      before :each do
        @user = create(:user)
        @new_attribute = attributes_for(:user)
        request.headers['Authorization'] = "Token token=\"#{@user.authentication_token}\", email=\"#{@user.email}\""
        put :update, id: @user, user: @new_attribute
      end
      it "updates the database" do
        user_response = json_response[:user]
        expect(user_response[:email]).to eq(@new_attribute[:email])
      end
      it { should respond_with 200 }
    end

    context "admin updates other user" do
      before :each do
        @user = create(:user)
        @admin = create(:admin)
        @new_attribute = attributes_for(:user)
        request.headers['Authorization'] = "Token token=\"#{@admin.authentication_token}\", email=\"#{@admin.email}\""
        put :update, id: @user, user: @new_attribute
      end
      it "updates the database" do
        user_response = json_response[:user]
        expect(user_response[:email]).to eq(@new_attribute[:email])
      end
      it { should respond_with 200 }
    end

    context "update user with invalid attributes" do
      before :each do
        @user = create(:user)
        @new_attribute = attributes_for(:invalid_user)
        request.headers['Authorization'] = "Token token=\"#{@user.authentication_token}\", email=\"#{@user.email}\""
        put :update, id: @user, user: @new_attribute
      end
      it "renders errors json_response" do
        user_response = json_response
        expect(user_response).to have_key :errors
      end
      it "renders why the errors happen" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end
      it { should respond_with 422 }
    end
  end

  describe "DELETE #destoy" do
    context 'user cancel the account' do
      before :each do
        @user = create(:user)
        request.headers['Authorization'] = "Token token=\"#{@user.authentication_token}\", email=\"#{@user.email}\""
        delete :destroy, id: @user
      end
      it { should respond_with 204 }
    end

    context 'admin delete other account' do
      before :each do
        @user = create(:user)
        @admin = create(:admin)
        request.headers['Authorization'] = "Token token=\"#{@admin.authentication_token}\", email=\"#{@admin.email}\""
        delete :destroy, id: @user
      end
      it { should respond_with 204 }
    end
  end
end
