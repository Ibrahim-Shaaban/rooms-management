require 'rails_helper'

describe Reservation::CancelService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  describe '#call' do
    context 'when canceling a reservation' do
      it 'destroys the reservation' do
        start_date = Date.today + 1
        end_date = start_date + 3
        reservation = create(:reservation, room: room, start_date: start_date, end_date: end_date, user: user)

        service = Reservation::CancelService.new(reservation: reservation)

        expect { service.call }.to change(Reservation, :count).by(-1)
      end
    end

    context 'when the reservation does not exist' do
      it 'raises an error' do
        non_existent_reservation = nil

        service = Reservation::CancelService.new(reservation: non_existent_reservation)

        expect { service.call }.to raise_error()
      end
    end
  end
end