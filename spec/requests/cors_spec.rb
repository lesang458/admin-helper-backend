require 'rails_helper'
RSpec.describe 'the requests support CORS headers', type: :request do
  before(:all) { @admin = FactoryBot.create(:user, :admin, first_name: 'user', last_name: 'admin') }
  let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
  it 'Returns the response CORS headers' do
    get '/api/v1/employees', headers: { Origin: 'localhost', authorization: "Bearer #{valid_token}" }
    expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
    expect(response.headers['Access-Control-Allow-Methods']).to eq('GET, POST, PUT, DELETE, OPTIONS')
  end
end
