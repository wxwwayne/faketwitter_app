require 'rails_helper'
describe UsersController do
  shared_examples 'public access' do
    describe 'GET #show' do
      let(:user) do
        create(:user)
      end
      it "assigns the requested user to @user" do
        get :show, id: user
        expect(assigns(:user)).to eq user
      end
      it "renders the :show template" do
        get :show, id: user
        expect(response).to render_template :show
      end
    end


    describe 'GET #new' do
      it "assigns a new User to @user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
      it "renders the :new template" do
        #pending "not necessary"
        get :new
        expect(response).to render_template :new
      end
    end
  end

  shared_examples 'user access' do
    describe 'PATCH #update' do
      context "valid attribute" do
        it "locates the requested @user" do
          patch :update, id: @user, user: attributes_for(:user)
          expect(assigns(:user)).to eq(@user)
        end
        it "updates the @user's attribute" do
          patch :update, id: @user, user: attributes_for(:user,
                                                         name: "After Update",
                                                         email: "after@update.com")
          @user.reload
          expect(@user.name).to eq "After Update"
          expect(@user.email).to eq "after@update.com"
        end
        it "redirects to updated user" do
          patch :update, id: @user, user: attributes_for(:user)
          expect(response).to redirect_to @user
        end
      end

      context "invalid attribute" do
        it "doesn't update attributes" do
          patch :update, id: @user,
            user: attributes_for(:invalid_user)
          expect(@user.name).to eq 'Wayne Wang'
          expect(@user.email).to eq "wayne@wang.com"
        end
      end
    end
    describe 'GET #index' do
      it "gets all users in index" do
        user_one = create(:user)
        get :index
        expect(assigns[:users]).to eq [@user, user_one]
      end
    end
  end
  shared_examples 'admin access' do
    describe "DELETE #destroy" do
      it "delete the @user" do
        expect{
          delete :destroy, id: @user
        }.to change(User, :count).by (-1)
      end
    end
  end

  describe 'admin access to controller' do
    before :each do
      @user = create(:wayne)
      log_in_as(@user)
    end

    it_behaves_like 'public access'
    it_behaves_like 'user access'
    it_behaves_like 'admin access'
  end

  describe 'user access to controller' do
    before :each do
      @user = create(:wayne,
                     admin: false)
      log_in_as(@user)
    end
    it_behaves_like 'public access'
    it_behaves_like 'user access'
  end

  describe 'public access to controller' do
    it_behaves_like 'public access'
  end

end
