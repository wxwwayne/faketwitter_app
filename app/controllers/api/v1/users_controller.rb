class Api::V1::UsersController < Api::V1::BaseController
  # respond_to :json
  # include ActiveHashRelation

  def show
    user = User.find(params[:id])
    render json: user, serializer: Api::V1::UserSerializer
  end

  def index
    users = User.all
    # users = apply_filters(users, params)
    users = params[:user_ids].present? ? User.find(params[:user_ids]) : User.all

    render json: users,
      each_serializer: Api::V1::UserSerializer,
      root: 'users'
  end

  # def create
  #   user = User.new(user_params)
  #   if user.save
  #     render json: user, serializer: Api::V1::UserSerializer,
  #       status: 201, location: [:api, user]
  #   else
  #     render json: { errors: user.errors }, status: 422
  #   end
  # end
end

# private
# def user_params
#   params.require(:user).permit(:name, :email, :password,
#                                :password_confirmation)
# end
