require 'rails_helper'

describe Room::AvailableForReservationService do
    let(:user) { create(:user) }
    describe '#call' do
      context 'when there are available rooms' do
        it 'returns a list of available rooms' do
          # Create rooms and reservations for testing
          room1 = create(:room, number:"100")
          room2 = create(:room, number:"101")
          room3 = create(:room, number:"102")
  
          reservation1 = create(:reservation, room: room1, start_date: Date.today - 2, end_date: Date.today, user: user)
          reservation2 = create(:reservation, room: room2, start_date: Date.today + 2, end_date: Date.today + 4, user: user)
  
          service = Room::AvailableForReservationService.new(
            start_date: Date.today.to_s, end_date: (Date.today + 1).to_s
          )
  
          available_rooms = service.call
  
          expect(available_rooms).to include(room2)
          expect(available_rooms).to include(room3)
          expect(available_rooms).not_to include(room1)
        end
      end
  
      context 'when there are no available rooms' do
        it 'returns an empty list' do
          # Create a reservation that overlaps with the date range
          room1 = create(:room)
          reservation1 = create(:reservation, room: room1, start_date: Date.today - 1, end_date: Date.today + 1, user: user)
  
          service = Room::AvailableForReservationService.new(
            start_date: Date.today.to_s, end_date: (Date.today + 2).to_s
          )
  
          available_rooms = service.call
  
          expect(available_rooms).to be_empty
        end
      end
    end
  end