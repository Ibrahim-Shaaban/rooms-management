class RoomSerializer
  include JSONAPI::Serializer
  attributes :number, :price_per_night, :room_type
end
