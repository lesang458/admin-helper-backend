require 'rails_helper'
RSpec.describe 'the requests support CORS headers', type: :request do
  it 'Returns the response CORS headers' do
    get '/api/v1/employees'
    expect(response.headers['Access-Control-Allow-Methods']).to eq('GET, POST, DELETE, OPTIONS')
  end
end
