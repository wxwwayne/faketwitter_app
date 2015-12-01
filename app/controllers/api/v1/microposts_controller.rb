class Api::V1::MicropostsController < Api::V1::BaseController
  before_filter :authenticate_user!


  def show
    micropost = Micropost.find(params[:id])
    # authorize micropost

    render json: micropost, serializer: Api::V1::MicropostSerializer
  end

  def index
    if params[:feed]
      return api_error(status:422) if params[:feed_user_id].blank?
      return unauthorized! unless current_user.id == params[:feed_user_id].to_i

      microposts = User.find_by(id: params[:feed_user_id]).feed
    else
      microposts = params[:user_id].present? ? Micropost.where(user_id: params[:user_id]) : Micropost.all
      if !params[:page]
        params[:page] = 1
        params[:per_page] = 100
      end

      microposts = microposts.page(params[:page].to_f).per(params[:per_page].to_f)
    end
    render json: microposts,
      each_serializer: Api::V1::MicropostSerializer,
      root: 'microposts',
      meta: { pagination:
              { per_page: params[:per_page],
                total_pages: microposts.total_pages,
                total_objects: microposts.total_count } }
      end

  def create
    # micropost = Micropost.new(micropost_params)
    micropost = current_user.microposts.new(micropost_params)
    if micropost.save
      render json: micropost, serializer: Api::V1::MicropostSerializer,
        status: 201, location: api_v1_micropost_url(micropost.id)
    else
      render json: { errors: micropost.errors }, status: 422
    end
  end

  def update
    micropost = Micropost.find(params[:id])
    if micropost.update_attributes(micropost_params)
      render json: micropost, serializer: Api::V1::MicropostSerializer,
        status: 200, location: api_v1_micropost_url(micropost.id)
    else
      render json: { errors: micropost.errors }, status: 422
    end
  end

  def destroy
    micropost = Micropost.find(params[:id])
    micropost.destroy
    head 204
  end

  private
  def micropost_params
    # params.require(:micropost).permit(:content, :picture, :user_id)
    params.require(:micropost).permit(:content, :picture)
  end
end
