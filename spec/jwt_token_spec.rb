require 'rails_helper'
require 'spec_helper'
RSpec.describe JwtToken do
  payload = { 'id' => 1 }
  secret = 'secret_key'
  it 'responds with a JWT' do
    token = JwtToken.encode payload, secret
    expect(token).to be_kind_of(String)
    segments = token.split('.')
    expect(segments.size).to eql(3)
  end

  it 'should decode a valid token' do
    token = JwtToken.encode payload, secret
    body = JwtToken.decode token, secret
    expect(body).to eq payload
  end

  it 'should raise ExceptionHandler::DecodeError with wrong key' do
    wrong_key = 'wrong-secret-key'
    expect do
      JwtToken.decode nil, wrong_key
    end.to raise_error ExceptionHandler::DecodeError
  end

  it 'should raise ExceptionHandler::DecodeError with invalid token' do
    expect do
      JwtToken.decode nil, 'wrong-token'
    end.to raise_error ExceptionHandler::DecodeError
  end

  it 'should raise ExceptionHandler::ExpiredSignature with expired token' do
    time_out_token = JwtToken.encode payload, 24.hours.ago, secret
    expect do
      JwtToken.decode time_out_token, secret
    end.to raise_error ExceptionHandler::ExpiredSignature
  end
end
