class Api::V1::UserSerializer < Api::V1::BaseSerializer
  embed :ids
  attributes :id, :email, :name, :authentication_token, :created_at, :updated_at

  has_many :microposts
  has_many :following
  has_many :followers
end
