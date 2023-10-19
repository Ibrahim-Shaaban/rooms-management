class ReservationSerializer
  include JSONAPI::Serializer
  attributes :start_date, :end_date

  belongs_to :user
  belongs_to :room
end
