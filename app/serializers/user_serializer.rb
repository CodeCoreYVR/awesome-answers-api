class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :full_name, # You can include custom methods to be serialized
    :created_at,
    :updated_at
  )
end
