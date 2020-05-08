require 'rails_helper'
require 'spec_helper'
RSpec.describe JwtToken do
  payload = { 'id' => 1 }
  it 'responds with a JWT' do
    token = JwtToken.encode payload
    expect(token).to be_kind_of(String)
    segments = token.split('.')
    expect(segments.size).to eql(3)
  end

  it 'should decode a valid token' do
    token = JwtToken.encode payload
    body = JwtToken.decode token
    expect(body).to eq payload
  end

  it 'should raise ExceptionHandler::DecodeError with invalid token' do
    expect do
      JwtToken.decode nil
    end.to raise_error ExceptionHandler::DecodeError
  end

  it 'should raise ExceptionHandler::ExpiredSignature with expired token' do
    time_out_token = JwtToken.encode payload, 24.hours.ago
    expect do
      JwtToken.decode time_out_token
    end.to raise_error ExceptionHandler::ExpiredSignature
  end
end
