#require 'rails_helper'
#describe 'GET #show' do
# 	it "assigns the requested user to @user" do
#     	user = create(:user)
#     	get :show, id: user
#     	expect(assigns(:user)).to eq user
# 	end
# 	it "renders the :show template" do 
# 		user = create(:user)
# 		get :show, id: user
# 		expect(response).to render_template :show
# 	end
#end
# describe 'GET #new' do
# 	it "assigns a new User to @user" do
# 		get :new
# 		expect(assigns(:user)).to be_a_new(User) 
# 	end
# 	it "renders the :new template" do 
# 		get :new
# 		expect(response).to render_template :new 
# 	end
# end