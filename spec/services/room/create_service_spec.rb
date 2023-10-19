require 'rails_helper'

describe Room::CreateService do
  describe '#call' do
    let(:number) { "100" }
    let(:room_type) { "single" }
    let(:price_per_night) { 105.5 }

    it 'creates a room with valid attributes' do
      service = Room::CreateService.new(number: number, room_type: room_type, price_per_night: price_per_night)
      expect { service.call }.to change { Room.count }.by(1)

      created_room = Room.last
      expect(created_room.number).to eq(number)
      expect(created_room.room_type).to eq(room_type)
      expect(created_room.price_per_night).to eq(price_per_night)
    end
  end
end