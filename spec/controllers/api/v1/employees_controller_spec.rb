require 'rails_helper'
require 'jwt_token'

RSpec.describe Api::V1::EmployeesController, type: :controller do
  before { FactoryBot.create_list(:employee, 50) }

  describe 'token' do
    let!(:valid_token) { JwtToken.encode({ user_id: User.first.id }) }
    let!(:valid_headers) { { authorization: valid_token } }
    let!(:invalid_token) { SecureRandom.hex(64) }
    let!(:invalid_headers) { { authorization: invalid_token } }
    before(:each) { request.headers.merge! valid_headers }

    describe 'GET# employee' do
      it 'should pass with real param id' do
        get :show, params: { id: Employee.first.id }
        expect(response.status).to eq(200)
      end

      it 'return status 404 with fake param id' do
        get :show, params: { id: 'fake_id' }
        expect(response.status).to eq(404)
      end

      it 'return status 401 with token false' do
        request.headers.merge! invalid_headers
        get :show, params: { id: Employee.first.id }
        expect(response.status).to eq(401)
      end
    end

    describe 'GET#list employees' do
      it 'should status 200 with birthday and joned company date' do
        get :index, params: { birthday_from: '1995-10-30', birthday_to: '1999-10-30', joined_company_date_from: '2015-11-24', joined_company_date_to: '2020-01-24', status: 'ACTIVE' }
        expect(response.status).to eq(200)
      end

      it 'should status 401 with token false' do
        request.headers.merge! invalid_headers
        get :index, params: { birthday_from: '1995-10-30', birthday_to: '1999-10-30', joined_company_date_from: '2015-11-24', joined_company_date_to: '2020-01-24', status: 'ACTIVE' }
        expect(response.status).to eq(401)
      end

      it 'should pass with token and non params' do
        get :index
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(20)
        expect(json_response['total_pages']).to eq(3)
        expect(json_response['total_count']).to eq(50)
      end

      it 'should pass with token and params' do
        get :index, params: { per_page: 3, page: 3 }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(3)
        expect(json_response['page_size']).to eq(3)
        expect(json_response['total_pages']).to eq(17)
        expect(json_response['total_count']).to eq(50)
      end

      it 'return status 401 with token false' do
        request.headers.merge! invalid_headers
        get :index
        expect(response.status).to eq(401)
      end
    end
  end
end
