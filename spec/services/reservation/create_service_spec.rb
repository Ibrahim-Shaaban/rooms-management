require 'rails_helper'

describe Reservation::CreateService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }

  describe '#call' do
    context 'when creating a valid reservation' do
      it 'creates a reservation' do
        start_date = Date.today + 1
        end_date = start_date + 3

        service = Reservation::CreateService.new(
          room: room,
          start_date: start_date.to_s,
          end_date: end_date.to_s,
          user: user
        )

        expect { service.call }.to change(Reservation, :count).by(1)
      end
    end

    context 'when there is existed reservation with the same data' do
      it "doesn't create the reservation" do
        # Create a reservation that overlaps with the desired date range
        start_date = Date.today + 1
        end_date = start_date + 3
        create(:reservation, room: room, start_date: start_date, end_date: end_date, user: user)

        # Attempt to make a reservation for the same room during the overlap
        service = Reservation::CreateService.new(
          room: room,
          start_date: start_date.to_s,
          end_date: end_date.to_s,
          user: user
        )

        expect { service.call }.not_to change(Room, :count)
      end
    end
  end
end