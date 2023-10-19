require 'rails_helper'

describe User::SignInService do
  let(:valid_user_name) { 'example_user' }
  let(:valid_password) { 'password' }
  let(:invalid_user_name) { 'nonexistent_user' }
  let(:invalid_password) { 'wrong_password' }

  let(:user) { create(:user, user_name: valid_user_name, password: valid_password) }

  describe '#call' do
    context 'with valid credentials' do
      it 'returns a token and expiration time' do
        service = User::SignInService.new(user_name: user.user_name, password: valid_password)
        result = service.call
        

        expect(result).to have_key(:token)
        expect(result).to have_key(:expires_at)
      end
    end

    context 'with invalid user_name' do
      it 'raises an error' do
        service = User::SignInService.new(user_name: invalid_user_name, password: valid_password)

        expect { service.call }.to raise_error("Invalid credentials")
      end
    end

    context 'with invalid password' do
        it 'raises an error' do
          service = User::SignInService.new(user_name: valid_user_name, password: invalid_password)
  
          expect { service.call }.to raise_error("Invalid credentials")
        end
      end
  end
end