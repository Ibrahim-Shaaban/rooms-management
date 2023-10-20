require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do

  describe "POST #create" do
    context "given valid parameters" do
      let(:params) { {number: "100", room_type: "single", price_per_night: 105.5 } }

      it "creates a new room and returns HTTP status :created" do
        expect {
          post :create, params: params
        }.to change(Room, :count).by(1)

        expect(response).to have_http_status(:created)

      end
    end

    context "given invalid parameters" do
      let(:params) { {  } }

      it "does not create a new room and returns HTTP status :unprocessable_entity" do
        expect {
          post :create, params: params
        }.not_to change(Room, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "given invalid parameters" do
        
        let(:number) { "100" }
        let(:room_type) { "single" }
        let(:price_per_night) { 105.5 }    
        let(:params) { { number: number, room_type: room_type, price_per_night: price_per_night } }
        
  
        it "does not create a new room and returns HTTP status :unprocessable_entity" do
            room = create(:room, number: number, room_type: room_type, price_per_night: price_per_night)
          expect {
            post :create, params: params
          }.not_to change(Room, :count)
  
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

  end

  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:valid_attributes) do
    {
      start_date: Date.today + 1,
      end_date: Date.today + 4
    }
  end

  describe 'POST #make_reservation' do
    context 'with valid parameters' do
      it 'creates a new reservation' do
        jwt_token = JsonWebToken.encode({id: user.id}) 

        request.headers['Authorization'] = "Bearer #{jwt_token}"
        expect do
          post :make_reservation, params: { id: room.id, **valid_attributes }, format: :json
        end.to change(Reservation, :count).by(1)

        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error message' do
        jwt_token = JsonWebToken.encode({id: user.id}) 

        request.headers['Authorization'] = "Bearer #{jwt_token}"
        # Simulate an unavailable room
        create(:reservation, room: room, start_date: valid_attributes[:start_date], end_date: valid_attributes[:end_date], user: user)

        post :make_reservation, params: { id: room.id, **valid_attributes }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end

    context 'when not signed in' do
      it 'returns an unauthorized status' do
        post :make_reservation, params: { id: room.id, **valid_attributes }, format: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  let(:reservation){ create(:reservation, room: room, start_date: valid_attributes[:start_date], end_date: valid_attributes[:end_date], user: user)} 

  describe 'DELETE #cancel_reservation' do
    context 'with a valid reservation' do
      it 'cancels the reservation' do
        jwt_token = JsonWebToken.encode({id: user.id}) 

        request.headers['Authorization'] = "Bearer #{jwt_token}"
        reservation_count = Reservation.count

        delete :cancel_reservation, params: { reservation_id: reservation.id }, format: :json

        expect(response).to have_http_status(:success)
      end
    end

    context 'with an invalid reservation' do
      it 'returns an error message' do
        jwt_token = JsonWebToken.encode({id: user.id}) 

        request.headers['Authorization'] = "Bearer #{jwt_token}"

        delete :cancel_reservation, params: { reservation_id: 'non_existent_reservation_id' }, format: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end

    context 'when not signed in' do
      it 'returns an unauthorized status' do
        delete :cancel_reservation, params: { reservation_id: reservation.id }, format: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #available' do
    context 'with valid parameters' do
      it 'returns a list of available rooms' do
        jwt_token = JsonWebToken.encode({id: user.id}) 

        request.headers['Authorization'] = "Bearer #{jwt_token}"
        valid_start_date = Date.today + 1
        valid_end_date = Date.today + 2

        get :available, params: { start_date: valid_start_date.to_s, end_date: valid_end_date.to_s }, format: :json

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to have_key('data')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error message' do
        jwt_token = JsonWebToken.encode({id: user.id}) 

        request.headers['Authorization'] = "Bearer #{jwt_token}"
        invalid_start_date = Date.today
        invalid_end_date = Date.today - 2

        get :available, params: { start_date: invalid_start_date, end_date: invalid_end_date }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end

    context 'when not signed in' do
      it 'returns an unauthorized status' do
        valid_start_date = Date.today
        valid_end_date = Date.today + 2

        get :available, params: { start_date: valid_start_date, end_date: valid_end_date }, format: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end


end