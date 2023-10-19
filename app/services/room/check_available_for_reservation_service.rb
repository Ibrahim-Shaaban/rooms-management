class Room::CheckAvailableForReservationService
    
    def initialize(room:, start_date:, end_date:)
        @room = room
        @start_date = Date.parse(start_date)
        @end_date = Date.parse(start_date)
    end

    def call 
        check_room_is_available?
    end

    private

    def check_room_is_available?
        # Find overlapping reservations
        overlapping_reservations = @room.reservations.where('start_date <= ? AND end_date >= ?', @end_date, @start_date)

        # Check if there are any reservations that conflict with the provided dates
        if overlapping_reservations.any?
            return false
        end

        true

        # # Check for potential gaps between reservations
        # reservations = @room.reservations.order(:start_date)

        # return true if reservations.empty?  # If there are no existing reservations

        # last_end_date = reservations.first.start_date
        # reservations.each do |reservation|
        #     if @start_date > last_end_date && @end_date < reservation.start_date
        #         return true
        #     end
        #     last_end_date = reservation.end_date
        # end

        # false
        
    end
end