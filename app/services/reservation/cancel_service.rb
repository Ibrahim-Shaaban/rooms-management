class Reservation::CancelService
    
    def initialize(reservation: )
        @reservation = reservation
    end

    def call 
        cancel_reservation
    end

    private

    def cancel_reservation
        @reservation.destroy!
    end
end