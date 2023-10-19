class Room::CreateService 

    def initialize(number:, room_type:, price_per_night:)
        @number = number
        @room_type = room_type
        @price_per_night = price_per_night
    end

    def call 
        create_room
    end


    private

    def create_room 
        Room.create!(number: @number, room_type: @room_type, price_per_night: @price_per_night)
    end
end