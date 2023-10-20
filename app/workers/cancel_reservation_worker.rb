class CancelReservationWorker
    include Sidekiq::Worker
  
    sidekiq_options retry: 3
  
    def perform(reservation_id)
        Reservation::CancelService.new(reservation: Reservation.find(reservation_id)).call 
    end
  end