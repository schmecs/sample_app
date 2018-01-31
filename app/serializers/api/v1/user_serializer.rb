class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :name, :email

  has_many :microposts, serializer: Api::V1::MicropostSerializer
  
end
