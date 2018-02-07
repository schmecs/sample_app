class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email

  has_many :microposts, serializer: Api::V1::MicropostSerializer
	has_many :following, through: :active_relationships, source: :followed, serializer: Api::V1::UserSerializer
	has_many :followers, through: :passive_relationships, source: :follower, serializer: Api::V1::UserSerializer
  
end
