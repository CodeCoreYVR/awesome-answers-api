class QuestionCollectionSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :title,
    :body,
    :created_at,
    :view_count
    )
end
