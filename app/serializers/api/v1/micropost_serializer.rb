class Api::V1::MicropostSerializer < ActiveModel::Serializer
  attributes :content, :created_at

  belongs_to :user
end
