require 'rails_helper'

describe User::CreateService do
  describe '#call' do
    context 'with valid parameters' do
      it 'creates a user' do
        service = User::CreateService.new(user_name: 'example_user', password_digest: 'password')
        expect { service.call }.to change { User.count }.by(1)
      end
    end

    context 'with missing user_name or password_digest' do
      it 'raises an error' do
        service = User::CreateService.new(user_name: nil, password_digest: 'password')
        expect { service.call }.to raise_error(RuntimeError, 'user_name or password digest not found , please provide them')

        service = User::CreateService.new(user_name: 'example_user', password_digest: nil)
        expect { service.call }.to raise_error(RuntimeError, 'user_name or password digest not found , please provide them')
      end
    end
  end
end