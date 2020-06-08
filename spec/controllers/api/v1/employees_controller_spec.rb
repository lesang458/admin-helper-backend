require 'rails_helper'
require 'jwt_token'

RSpec.describe Api::V1::EmployeesController, type: :controller do
  before(:each) do
    Employee.delete_all
  end
  before { FactoryBot.create(:employee, first_name: 'aaabbbccc', last_name: 'gmail.com', phone_number: '0935208940') }
  before { @employee = FactoryBot.create(:employee, first_name: 'Tran', last_name: 'Huy', phone_number: '0935270046') }
  describe 'token' do
    let!(:valid_token) { JwtToken.encode({ user_id: User.first.id }) }
    let!(:valid_headers) { { authorization: valid_token } }
    let!(:invalid_token) { SecureRandom.hex(64) }
    let!(:invalid_headers) { { authorization: invalid_token } }

    before(:each) { request.headers.merge! valid_headers }

    describe 'POST# employee' do
      it 'return status 401 with token false' do
        request.headers.merge! invalid_headers
        get :index
        expect(response.status).to eq(401)
      end

      it 'should return 201' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: 'danghanh@mail.com', birthday: '1999-02-02', joined_company_date: '2019-11-23', phone_number: '0123456789' }
        expect(response.status).to eq(201)
      end

      it 'should return 201 without phone_number' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: 'danghanh@mail.com', birthday: '1999-02-02', joined_company_date: '2019-11-23' }
        expect(response.status).to eq(201)
      end

      it 'should return 422 with empty email' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: '', birthday: '1999-02-02', joined_company_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end

      it 'should return 422 with invalid email' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: 'danghanh@', birthday: '1999-02-02', joined_company_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end

      it 'should return 422 with invalid email' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: 'danghanh@gmail', birthday: '1999-02-02', joined_company_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end

      it 'should return 400 with empty first_name' do
        post :create, params: { first_name: '', last_name: 'hanh', email: 'danghanh+1@mail.com', birthday: '1999-02-02', joined_company_date: '2019-11-23' }
        expect(response.status).to eq(400)
      end

      it 'should return 400 with empty last_name' do
        post :create, params: { first_name: 'dang', last_name: '', email: 'danghanh+1@mail.com', birthday: '1999-02-02', joined_company_date: '2019-11-23' }
        expect(response.status).to eq(400)
      end

      it 'should return 400 without first_name' do
        post :create, params: { last_name: 'hanh', email: 'danghanh+1@mail.com', birthday: '1999-02-02', joined_company_date: '2019-11-23' }
        expect(response.status).to eq(400)
      end

      it 'should return 400 without last_name' do
        post :create, params: { first_name: 'dang', email: 'danghanh+1@mail.com', birthday: '1999-02-02', joined_company_date: '2019-11-23' }
        expect(response.status).to eq(400)
      end

      it 'should return 400 with birthday is after today' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: 'danghanh@gmail.com', birthday: '2999-02-02', joined_company_date: '2019-11-23' }
        expect(response.status).to eq(400)
      end
    end
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
      it 'should pass with token and params search' do
        get :index, params: { search: Employee.first.first_name }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(1)
        expect(json_response['total_pages']).to eq(1)
        expect(json_response['total_count']).to eq(1)
      end

      it 'should return 200' do
        get :index, params: { search: 'trannnn' }
        expect(response.status).to eq(200)
      end

      it 'should pass with token and return 204' do
        get :index, params: { search: '404 Not Found' }
        expect(response.status).to eq(200)
      end

      it 'shoud pass with upper case' do
        get :index, params: { search: Employee.first.last_name.upcase }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(1)
        expect(json_response['total_pages']).to eq(1)
        expect(json_response['total_count']).to eq(1)
      end

      it 'should pass with lower case' do
        get :index, params: { search: Employee.first.last_name.downcase }
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(1)
        expect(json_response['total_pages']).to eq(1)
        expect(json_response['total_count']).to eq(1)
      end

      it 'should pass with phone number and return 200' do
        get :index, params: { search: '093527', per_page: 1, page: 3 }
        expect(response.status).to eq(200)
      end

      it 'should pass with phone number and return 200' do
        get :index, params: { search: '093527', per_page: 1, page: 1 }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(1)
        expect(json_response['total_pages']).to eq(1)
        expect(json_response['total_count']).to eq(1)
      end

      it 'should pass with token and params search and params pagination' do
        get :index, params: { per_page: 3, page: 3, search: '0123456789' }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(3)
        expect(json_response['page_size']).to eq(0)
        expect(json_response['total_pages']).to eq(0)
        expect(json_response['total_count']).to eq(0)
      end

      it 'should pass with token and non params' do
        get :index
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(2)
        expect(json_response['total_pages']).to eq(1)
        expect(json_response['total_count']).to eq(2)
      end

      it 'should pass with token and params' do
        get :index, params: { per_page: 3, page: 3 }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(3)
        expect(json_response['page_size']).to eq(0)
        expect(json_response['total_pages']).to eq(1)
        expect(json_response['total_count']).to eq(2)
      end

      it 'return status 401 with token false' do
        request.headers.merge! invalid_headers
        get :index
        expect(response.status).to eq(401)
      end
    end
  end
end
