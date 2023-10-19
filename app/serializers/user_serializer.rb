class UserSerializer
  include JSONAPI::Serializer
  attributes :user_name, :created_at
end

