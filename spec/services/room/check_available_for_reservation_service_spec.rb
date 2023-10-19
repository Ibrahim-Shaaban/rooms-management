require 'rails_helper'

describe Room::CheckAvailableForReservationService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }

  describe '#call' do
    context 'when the room is available' do
      it 'returns true' do
        start_date = Date.today + 1
        end_date = start_date + 3

        service = Room::CheckAvailableForReservationService.new(
          room: room,
          start_date: start_date.to_s,
          end_date: end_date.to_s
        )

        expect(service.call).to be true
      end
    end

    context 'when the room is not available due to overlapping reservation' do
      it 'returns false' do
        # Create a reservation that overlaps with the desired date range
        start_date = Date.today + 1
        end_date = start_date + 3
        create(:reservation, room: room, user: user, start_date: start_date, end_date: end_date)

        # Attempt to make a reservation for the same room during the overlap
        service = Room::CheckAvailableForReservationService.new(
          room: room,
          start_date: start_date.to_s,
          end_date: end_date.to_s
        )

        expect(service.call).to be false
      end
    end

    context 'when the room is not available due to gap between reservations' do
      it 'returns false' do
        # Create a reservation with a gap before it
        start_date = Date.today + 1
        end_date = start_date + 3
        create(:reservation, room: room, user: user, start_date: start_date, end_date: end_date)

        # Attempt to make a reservation with a gap before it
        new_start_date = start_date + 1
        new_end_date = new_start_date + 1

        service = Room::CheckAvailableForReservationService.new(
          room: room,
          start_date: new_start_date.to_s,
          end_date: new_end_date.to_s
        )

        expect(service.call).to be false
      end
    end
  end
end