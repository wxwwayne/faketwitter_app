class Api::V1::MicropostSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :content, :picture, :created_at, :updated_at

  has_one :user

  def picture
    object.picture.url
  end
end
