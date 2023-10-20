class Reservation::CreateService

    def initialize(room:, start_date:, end_date:, user:)
        @room = room
        @start_date = Date.parse(start_date)
        @end_date = Date.parse(end_date)
        @user = user
    end

    def call 
        make_reservation
    end

    private

    def make_reservation 
        Reservation.create!(user: @user, room: @room, start_date: @start_date, end_date: @end_date)
    end
end