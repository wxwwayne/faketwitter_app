class Api::V1::UserSerializer < Api::V1::BaseSerializer
  # embed :ids
  attributes :id, :email, :name

  has_many :microposts
  # has_many :following
  # has_many :followers

  # def created_at
  #   object.created_at.in_time_zone.ios8601 if object.created_at
  # end

  # def updated_at
  #   object.updated_at.in_time_zone.ios8601 if object.updated_at
  # end
end
