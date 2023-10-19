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


end