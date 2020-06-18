require 'rails_helper'
require 'jwt_token'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:all) do
    User.delete_all
    FactoryBot.create(:user, first_name: 'An', last_name: 'da')
    FactoryBot.create(:user, first_name: 'Bo', last_name: 'Ba')
    FactoryBot.create(:user, first_name: 'Ca', last_name: 'Co')
    FactoryBot.create(:user, first_name: 'Du', last_name: 'Da')
    @user = FactoryBot.create(:user, first_name: 'An', last_name: 'Ba')
  end

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
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: 'danghanh@mail.com', encrypted_password: '123456', birthdate: '1999-02-02', join_date: '2019-11-23',
                                phone_number: '0123456789' }
        expect(response.status).to eq(201)
      end

      it 'should return 201 without phone_number' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: 'danghanh@mail.com', encrypted_password: '123456', birthdate: '1999-02-02', join_date: '2019-11-23' }
        expect(response.status).to eq(201)
      end

      it 'should return 422 with empty email' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: '', birthdate: '1999-02-02', join_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end

      it 'should return 422 with invalid email' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: 'danghanh@', birthdate: '1999-02-02', join_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end

      it 'should return 422 with invalid email' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: 'danghanh@gmail', birthdate: '1999-02-02', join_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end

      it 'should return 422 with empty first_name' do
        post :create, params: { first_name: '', last_name: 'hanh', email: 'danghanh+1@mail.com', birthdate: '1999-02-02', join_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end

      it 'should return 422 with empty last_name' do
        post :create, params: { first_name: 'dang', last_name: '', email: 'danghanh+1@mail.com', birthdate: '1999-02-02', join_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end

      it 'should return 422 without first_name' do
        post :create, params: { last_name: 'hanh', email: 'danghanh+1@mail.com', birthdate: '1999-02-02', join_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end

      it 'should return 422 without last_name' do
        post :create, params: { first_name: 'dang', email: 'danghanh+1@mail.com', birthdate: '1999-02-02', join_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end

      it 'should return 422 with birthdate is after today' do
        post :create, params: { first_name: 'dang', last_name: 'hanh', email: 'danghanh@gmail.com', birthdate: '2999-02-02', join_date: '2019-11-23' }
        expect(response.status).to eq(422)
      end
    end

    describe 'sort' do
      it 'should returns sorted employee list with first_name' do
        get :index, params: { sort: 'first_name:ASC' }
        users = JSON.parse(response.body)['data']
        expect(users.first['first_name']).to eq('An')
        expect(users.second['first_name']).to eq('An')
        expect(users.third['first_name']).to eq('Bo')
      end

      it 'should returns sorted employee list with last_name' do
        get :index, params: { sort: 'last_name:ASC' }
        users = JSON.parse(response.body)['data']
        expect(users.first['last_name']).to eq('Ba')
        expect(users.second['last_name']).to eq('Ba')
        expect(users.third['last_name']).to eq('Co')
      end

      it 'should returns sorted employee list with last_name and first_name' do
        get :index, params: { sort: 'first_name:ASC,last_name:DESC' }
        users = JSON.parse(response.body)['data']
        expect(users.first['first_name']).to eq('An')
        expect(users.first['last_name']).to eq('da')
        expect(users.second['first_name']).to eq('An')
        expect(users.second['last_name']).to eq('Ba')
        expect(users.third['first_name']).to eq('Bo')
      end
    end

    describe 'GET# employee' do
      it 'should pass with real param id' do
        get :show, params: { id: User.first.id }
        expect(response.status).to eq(200)
      end

      it 'return status 404 with fake param id' do
        get :show, params: { id: 'fake_id' }
        expect(response.status).to eq(404)
      end

      it 'return status 401 with token false' do
        request.headers.merge! invalid_headers
        get :show, params: { id: User.first.id }
        expect(response.status).to eq(401)
      end
    end

    describe 'GET#list employees' do
      it 'should pass with real param id' do
        get :index, params: { sort: 'first_name:ASC,last_name:desc' }
        expect(response.status).to eq(200)
      end

      it 'should not pass with real param id' do
        get :index, params: { sort: 'first_nameq:ASC,last_name:desc' }
        expect(response.status).to eq(400)
      end
      it 'should status 200 with birthdate and joined company date' do
        get :index, params: { birthday_from: '1995-10-30', birthday_to: '1999-10-30', joined_company_date_from: '2015-11-24', joined_company_date_to: '2020-01-24', status: 'ACTIVE' }
        expect(response.status).to eq(200)
      end

      it 'should status 401 with token false' do
        request.headers.merge! invalid_headers
        get :index
        expect(response.status).to eq(401)
      end

      it 'should pass with token and params search' do
        get :index, params: { search: User.first.first_name }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(2)
        expect(json_response['total_pages']).to eq(1)
        expect(json_response['total_count']).to eq(2)
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
        get :index, params: { search: 'Tran'.upcase }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(0)
        expect(json_response['total_pages']).to eq(0)
        expect(json_response['total_count']).to eq(0)
      end

      it 'should pass with lower case' do
        get :index, params: { search: 'HUY'.downcase }
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(0)
        expect(json_response['total_pages']).to eq(0)
        expect(json_response['total_count']).to eq(0)
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
        expect(json_response['page_size']).to eq(0)
        expect(json_response['total_pages']).to eq(0)
        expect(json_response['total_count']).to eq(0)
      end

      it 'should pass with token and params search and params pagination' do
        get :index, params: { per_page: 3, page: 3, search: '0123456789' }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(3)
        expect(json_response['page_size']).to eq(0)
        expect(json_response['total_pages']).to eq(2)
        expect(json_response['total_count']).to eq(5)
      end

      it 'should pass with token and non params' do
        get :index
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(5)
        expect(json_response['total_pages']).to eq(1)
        expect(json_response['total_count']).to eq(5)
      end

      it 'should pass with token and params' do
        get :index, params: { per_page: 3, page: 3 }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(3)
        expect(json_response['page_size']).to eq(0)
        expect(json_response['total_pages']).to eq(2)
        expect(json_response['total_count']).to eq(5)
      end

      it 'return status 401 with token false' do
        request.headers.merge! invalid_headers
        get :index
        expect(response.status).to eq(401)
      end
    end
  end
end
