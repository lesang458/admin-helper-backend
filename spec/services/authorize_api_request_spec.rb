require 'rails_helper'
require 'jwt_token'

RSpec.describe AuthorizeApiRequest, type: :service do
  before { FactoryBot.create_list(:employee, 50) }

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
    let!(:invalid_token) { JwtToken.encode({ user_id: 404 }) }
    it 'should raise ExceptionHandler::Unauthorized if Could not find user' do
      expect do
        AuthorizeApiRequest.new(valid_token_flase).current_user
      end.to raise_error ExceptionHandler::Unauthorized
    end
    let!(:valid_token) { JwtToken.encode({ user_id: User.first.id }) }
    it 'should return user if find user' do
      user = AuthorizeApiRequest.new(valid_token_true).current_user
      expect(user.email).to eq User.first.email
    end
  end
end
