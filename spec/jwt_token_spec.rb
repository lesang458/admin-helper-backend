require 'rails_helper'
require 'spec_helper'
require 'jwt'
RSpec.describe JwtToken do
  payload = { 'id' => 1 }
  secret = 'secret_key'
  $token
  it 'responds with a JWT' do
    token = JwtToken.encode payload, secret
    $token = token
    expect(token).to be_kind_of(String)
    segments = token.split('.')
    expect(segments.size).to eql(3)
  end

  it 'should decode a valid token' do
    body = JwtToken.decode $token, secret
    expect(body).to eq payload
  end

  it 'wrong key should raise ExceptionHandler::DecodeError' do
    wrong_key = 'wrong-secret-key'
    expect do
      JwtToken.decode nil, wrong_key
    end.to raise_error ExceptionHandler::DecodeError
  end

  it 'wrong token should raise ExceptionHandler::DecodeError' do
    wrong_token = 'wrong-token'
    expect do
      JwtToken.decode nil, secret
    end.to raise_error ExceptionHandler::DecodeError
  end

  it 'time out should raise ExceptionHandler::ExpiredSignature' do
    time_out_token = JwtToken.encode payload, 24.hours.ago, secret
    expect do
      JwtToken.decode time_out_token, secret
    end.to raise_error ExceptionHandler::ExpiredSignature
  end
end
