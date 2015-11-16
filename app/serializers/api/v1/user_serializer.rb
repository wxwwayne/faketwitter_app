class Api::V1::UserSerializer < Api::V1::BaseSerializer
  embed :ids
  attributes :id, :email, :name

  has_many :microposts
  has_many :following
  has_many :followers
end
