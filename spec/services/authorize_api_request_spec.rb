require 'rails_helper'
require 'jwt_token'

RSpec.describe AuthorizeApiRequest, type: :service do
  before { FactoryBot.create_list(:user, 50) }

  payload = { 'id' => 404 }
  describe 'decode' do
    it 'should raise ExceptionHandler::DecodeError with token false' do
      expect do
        JwtToken.decode nil
      end.to raise_error ExceptionHandler::DecodeError
    end

    it 'should raise ExceptionHandler::DecodeError with token false' do
      time_out_token = JwtToken.encode payload, 24.hours.ago
      expect do
        JwtToken.decode time_out_token
      end.to raise_error ExceptionHandler::ExpiredSignature
    end
  end

  describe 'user' do
    let!(:valid_token) { JwtToken.encode({ user_id: User.first.id }) }
    let!(:invalid_token) { JwtToken.encode({ user_id: 1404 }) }
    it 'should raise ExceptionHandler::Unauthorized if Could not find user' do
      expect do
        AuthorizeApiRequest.new(invalid_token).current_user
      end.to raise_error ExceptionHandler::Unauthorized
    end
    it 'should return user if find user' do
      user = AuthorizeApiRequest.new(valid_token).current_user
      expect(user.email).to eq User.first.email
    end
  end
end
