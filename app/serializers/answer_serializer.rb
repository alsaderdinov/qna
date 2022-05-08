class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :created_at, :updated_at
  belongs_to :user
end
