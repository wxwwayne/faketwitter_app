class Api::V1::UsersController < Api::V1::BaseController
  # include ActiveHashRelation
  before_filter :authenticate_user!, only: [:show, :update, :destroy]

  def show
    user = User.find(params[:id])
    authorize user
    render json: user, serializer: Api::V1::UserSerializer
  end

  def index
    users = params[:user_ids].present? ? User.find(params[:user_ids]) : User.all
    if !params[:page]
      params[:page] = 1
      params[:per_page] = 100
    end
    users = users.page(params[:page].to_f).per(params[:per_page].to_f)

    render json: users,
      each_serializer: Api::V1::UserSerializer,
      root: 'users',
      meta: { pagination:
              { per_page: params[:per_page],
                total_pages: users.total_pages,
                total_objects: users.total_count } }
      end

  def create
    user = User.new(user_params)
    if user.save
      user.activate
      render json: user, serializer: Api::V1::UserSerializer,
        status: 201, location: api_v1_user_path(user.id)
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = User.find(params[:id])
    authorize user
    if user.update(user_params)
      render json: user, serializer: Api::V1::UserSerializer,
        status: 200, location: api_v1_user_path(user.id)
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    head 204
  end
end

private
def user_params
  params.require(:user).permit(:name, :email, :password,
                               :password_confirmation)
end
