require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe "POST #create" do
    context "given valid parameters" do
      let(:params) { { user_name: "user_new", password: "password" } }

      it "creates a new user and returns HTTP status :created" do
        expect {
          post :create, params: params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)

      end
    end

    context "given invalid parameters" do
      let(:params) { { user_name: "", password: "" } }

      it "does not create a new user and returns HTTP status :unprocessable_entity" do
        expect {
          post :create, params: params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end


  describe "POST #sign_in" do
    let(:user) { create(:user,user_name: "user_new_2", password: "password") }

    context "given valid user_name and password" do
      it "returns a token and expiration date" do
        post :sign_in, params: { user_name: user.user_name, password: "password" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("token", "expires_at")
      end
    end

    context "given invalid user_name" do
      it "returns an unauthorized status" do
        post :sign_in, params: { user_name: "invalid_user_name", password: "password" }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "given invalid password" do
      it "returns an unauthorized status" do
        post :sign_in, params: { user_name: user.user_name, password: "invalid_password" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end