require 'rails_helper'
RSpec.describe 'the requests support CORS headers', type: :request do
  it 'Returns the response CORS headers' do
    get '/api/v1/employees', params: {}, headers: { Origin: 'localhost' }
    expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
    expect(response.headers['Access-Control-Allow-Methods']).to eq('GET, POST, PUT, DELETE, OPTIONS')
  end
end
