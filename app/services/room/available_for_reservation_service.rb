class Room::AvailableForReservationService
    # get all available rooms for reservation is specific date range
    
    def initialize(start_date:, end_date:)
        @start_date = Date.parse(start_date)
        @end_date = Date.parse(end_date)
    end

    def call 
        get_all_available_rooms
    end

    private

    def get_all_available_rooms
        # Subquery to select room IDs with overlapping reservations
        subquery = Reservation.where('start_date <= ? AND end_date >= ?', @end_date, @start_date).select(:room_id)

        # Find rooms that are NOT in the list of reserved room IDs
        Room.where.not(id: subquery)
    end
end