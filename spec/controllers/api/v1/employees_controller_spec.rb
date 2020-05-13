require 'rails_helper'
require 'jwt_token'

RSpec.describe Api::V1::EmployeesController, type: :controller do
  before { FactoryBot.create_list(:employee, 50) }

  describe 'test use token' do
    let!(:valid_token) { JwtToken.encode({ user_id: 3195 }) }
    let!(:valid_headers) { { authorization: valid_token } }

    before(:each) { request.headers.merge! valid_headers }

    describe 'GET#list employees non params' do
      it 'should pass with my input and token' do
        get :index
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(20)
        expect(json_response['total_pages']).to eq(3)
        expect(json_response['total_count']).to eq(50)
      end
    end

    describe 'GET#list employees non params and token' do
      it 'should pass with my input' do
        get :index, params: { per_page: 3, page: 3 }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(3)
        expect(json_response['page_size']).to eq(3)
        expect(json_response['total_pages']).to eq(17)
        expect(json_response['total_count']).to eq(50)
      end
    end
  end

  describe 'token flase' do
    let!(:invalid_token) { SecureRandom.hex(64) }
    let!(:invalid_headers) { { authorization: invalid_token } }

    before(:each) { request.headers.merge! invalid_headers }

    it 'should render ExceptionHandler::DecodeError' do
      expect do
        JwtToken.decode nil
      end.to raise_error ExceptionHandler::DecodeError
    end

    it 'return status 401' do
      get :index
      expect(response.status).to eq(401)
    end
  end
end
