class Authorization::Room::CanUserCancelReservationService

    def initialize(user:, reservation_id:)
        @user = user 
        @reservation_id = reservation_id
    end

    def call 
        user_has_this_reservation
    end

    private

    def user_has_this_reservation
        Reservation.find_by(id: @reservation_id, user: @user).present? ? true : false
    end
end