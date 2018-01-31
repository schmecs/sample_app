class Api::V1::MicropostSerializer < ActiveModel::Serializer
  attributes :content

  belongs_to :user
end
