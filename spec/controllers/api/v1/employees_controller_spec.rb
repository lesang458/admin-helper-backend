require 'rails_helper'
require 'jwt_token'

RSpec.describe Api::V1::EmployeesController, type: :controller do
  before(:all) do
    DayOffRequest.delete_all
    DayOffInfo.delete_all
    DayOffCategory.delete_all
    DeviceHistory.delete_all
    User.delete_all
    @super_admin = FactoryBot.create(:user, :super_admin, first_name: 'An', last_name: 'da')
    @employee = FactoryBot.create(:user, first_name: 'Bo', last_name: 'Ba', roles: ['EMPLOYEE'])
    FactoryBot.create(:user, first_name: 'Ca', last_name: 'Co')
    FactoryBot.create(:user, first_name: 'Du', last_name: 'Da')
    @user = FactoryBot.create(:user, :admin, first_name: 'An', last_name: 'Ba')

    @category_vacation = FactoryBot.create(:day_off_category, :vacation)
    @category_illness = FactoryBot.create(:day_off_category, :illness)
    @info_vacation = FactoryBot.create(:day_off_info, :vacation, user_id: @user.id)
    @info_illness = FactoryBot.create(:day_off_info, :illness, user_id: @user.id)
  end

  describe 'token' do
    let!(:request_params) { { day_off_from_date: '2020-07-05', day_off_to_date: '2020-07-12' } }
    let!(:valid_token) { JwtToken.encode({ user_id: @user.id }) }
    let!(:valid_headers) { { authorization: "Bearer #{valid_token}" } }
    let!(:invalid_token) { SecureRandom.hex(64) }
    let!(:invalid_headers) { { authorization: "Bearer #{invalid_token}" } }
    before(:each) { request.headers.merge! valid_headers }

    describe 'PATCH# update status employee' do
      it 'return status 401 status code with invalid token' do
        request.headers.merge! invalid_headers
        patch :update_status, params: { id: @user.id }
        expect(response.status).to eq(401)
      end

      it 'should return 403 with employee' do
        valid_token = JwtToken.encode({ user_id: @employee.id })
        valid_headers = { authorization: "Bearer #{valid_token}" }
        request.headers.merge! valid_headers
        patch :update_status, params: { id: @user.id }
        expect(response.status).to eq(403)
      end

      it 'should return 200' do
        patch :update_status, params:
                                    {
                                      id: @user.id,
                                      status: 'ACTIVE'
                                    }
        @user.reload
        expect(response.status).to eq(200)
        expect(@user.status).to eq('ACTIVE')
      end

      it 'should return 200' do
        patch :update_status, params:
                                    {
                                      id: @user.id,
                                      status: 'FORMER'
                                    }
        @user.reload
        expect(response.status).to eq(200)
        expect(@user.status).to eq('FORMER')
      end

      it 'should return 422 with invalid status' do
        patch :update_status, params:
                                    {
                                      id: @user.id,
                                      status: 'ACTIVE fake'
                                    }
        expect(response.status).to eq(422)
      end

      it 'should return 422 with empty status' do
        patch :update_status, params:
                                    {
                                      id: @user.id,
                                      status: ''
                                    }
        expect(response.status).to eq(422)
      end
    end

    describe 'PATCH# update employee' do
      let!(:patch_params) {
        {
          id: @user.id,
          first_name: 'dang',
          last_name: 'hanh',
          email: 'danghanh@mail.com',
          birthdate: '1999-02-02',
          join_date: '2019-11-23',
          phone_number: '0123456789',
          day_off_infos_attributes:
          [
            {
              id: @info_vacation.id,
              day_off_category_id: @category_vacation.id,
              hours: 222
            },
            {
              id: @info_illness.id,
              day_off_category_id: @category_illness.id,
              hours: 160
            }
          ]
        }
      }
      it 'return status 401 status code with invalid token' do
        request.headers.merge! invalid_headers
        patch :update, params: { id: @user.id }
        expect(response.status).to eq(401)
      end

      it 'should return 403 with employee' do
        valid_token = JwtToken.encode({ user_id: @employee.id })
        valid_headers = { authorization: "Bearer #{valid_token}" }
        request.headers.merge! valid_headers
        patch :update, params: patch_params
        expect(response.status).to eq(403)
      end

      it 'should return 200' do
        patch :update, params: patch_params
        @user.reload
        @info_vacation.reload
        @info_illness.reload
        expect(response.status).to eq(200)
        expect(@user.first_name).to eq('dang')
        expect(@user.last_name).to eq('hanh')
        expect(@user.email).to eq('danghanh@mail.com')
        expect(@user.birthdate.to_s).to eq('1999-02-02')
        expect(@user.join_date.to_s).to eq('2019-11-23')
        expect(@user.phone_number).to eq('0123456789')
        expect(@info_vacation.hours).to eq(222)
        expect(@info_illness.hours).to eq(160)
      end

      it 'should return 422 with empty email' do
        params = patch_params.dup
        params[:email] = ''
        patch :update, params: params
        expect(response.status).to eq(422)
        expect(response.body).to include("Email can't be blank")
      end

      it 'should return 422 with invalid email' do
        params = patch_params.dup
        params[:email] = 'danghanh@'
        patch :update, params: params
        expect(response.status).to eq(422)
        expect(response.body).to include('Email is invalid')
      end

      it 'should return 422 with invalid email' do
        params = patch_params.dup
        params[:email] = 'danghanh@gmail'
        patch :update, params: params
        expect(response.status).to eq(422)
        expect(response.body).to include('Email is invalid')
      end

      it 'should return 422 with empty first_name' do
        params = patch_params.dup
        params[:first_name] = ''
        patch :update, params: params
        expect(response.body).to include("First name can't be blank")
        expect(response.status).to eq(422)
      end

      it 'should return 422 with empty last_name' do
        params = patch_params.dup
        params[:last_name] = ''
        patch :update, params: params
        expect(response.body).to include("Last name can't be blank")
        expect(response.status).to eq(422)
      end

      it 'should return 422 with birthdate is after today' do
        params = patch_params.dup
        params[:birthdate] = '2999-02-02'
        patch :update, params: params
        expect(response.body).to include('Birthdate is in future')
        expect(response.status).to eq(422)
      end

      it 'should return 422 with empty email day_off_infos cannot have the same day_off_category_id' do
        params = patch_params.dup
        params[:email] = ''
        patch :update, params: params
        expect(response.status).to eq(422)
        expect(response.body).to include("Email can't be blank")
      end

      it 'should return 422 with empty email' do
        params = patch_params.dup
        params[:email] = ''
        patch :update, params: params
        expect(response.status).to eq(422)
        expect(response.body).to include("Email can't be blank")
      end
    end

    describe 'POST# create employee' do
      let!(:employee_params) {
        {
          user:
          {
            first_name: 'dang',
            last_name: 'hanh',
            email: 'danghanh@mail.com',
            password: '123456',
            birthdate: '1999-02-02',
            join_date: '2019-11-23',
            phone_number: '0123456789',
            day_off_infos_attributes: [
              { day_off_category_id: @category_vacation.id, hours: 160 },
              { day_off_category_id: @category_illness.id, hours: 160 }
            ]
          }
        }
      }
      let!(:unexist_day_off_category_id) { @category_vacation.id + @category_illness.id }

      it 'should return 201' do
        params = employee_params.dup
        post :create, params: params
        expect(response.status).to eq(201)
      end

      it 'should return 201 without phone_number' do
        params = employee_params.dup
        params.delete(:phone_number)
        post :create, params: params
        expect(response.status).to eq(201)
      end

      it 'return status 401 status code with invalid token' do
        request.headers.merge! invalid_headers
        post :create, params: employee_params
        expect(response.status).to eq(401)
      end

      it 'should return 403 with employee' do
        valid_token = JwtToken.encode({ user_id: @employee.id })
        valid_headers = { authorization: "Bearer #{valid_token}" }
        request.headers.merge! valid_headers
        post :create, params: employee_params
        expect(response.status).to eq(403)
      end

      it 'should return 422 with unexist day_off_category_id' do
        params = employee_params.dup
        params[:user][:day_off_infos_attributes].first[:day_off_category_id] = unexist_day_off_category_id
        post :create, params: params
        expect(response.status).to eq(422)
        expect(response.body).to include('Day off infos day off category must exist')
      end

      it 'should return 422 with invalid hours' do
        params = employee_params.dup
        params[:user][:day_off_infos_attributes].first[:hours] = -160
        post :create, params: params
        expect(response.status).to eq(422)
        expect(response.body).to include('Day off infos hours must be greater than 0')
      end

      it 'should return 422 with empty email' do
        params = employee_params.dup
        params[:user][:email] = ''
        post :create, params: params
        expect(response.status).to eq(422)
      end

      it 'should return 422 with invalid email' do
        params = employee_params.dup
        params[:user][:email] = 'danghanh@'
        post :create, params: params
        expect(response.status).to eq(422)
      end

      it 'should return 422 with invalid email' do
        params = employee_params.dup
        params[:user][:email] = 'danghanh@gmail'
        post :create, params: params
        expect(response.status).to eq(422)
      end

      it 'should return 422 with empty first_name' do
        params = employee_params.dup
        params[:user][:first_name] = ''
        post :create, params: params
        expect(response.status).to eq(422)
      end

      it 'should return 422 with empty last_name' do
        params = employee_params.dup
        params[:user][:last_name] = ''
        post :create, params: params
        expect(response.status).to eq(422)
      end

      it 'should return 422 without first_name' do
        params = employee_params.dup
        params[:user].delete(:first_name)
        post :create, params: params
        expect(response.status).to eq(422)
      end

      it 'should return 422 without last_name' do
        params = employee_params.dup
        params[:user].delete(:last_name)
        post :create, params: params
        expect(response.status).to eq(422)
      end

      it 'should return 422 with birthdate is after today' do
        params = employee_params.dup
        params[:user][:birthdate] = '2999-02-02'
        post :create, params: params
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
      it 'should return 403 with employee' do
        valid_token = JwtToken.encode({ user_id: User.second.id })
        valid_headers = { authorization: "Bearer #{valid_token}" }
        request.headers.merge! valid_headers
        get :index
        expect(response.status).to eq(403)
      end

      it 'should return 200 with super_admin' do
        valid_token = JwtToken.encode({ user_id: @super_admin.id })
        valid_headers = { authorization: "Bearer #{valid_token}" }
        request.headers.merge! valid_headers
        get :index
        expect(response.status).to eq(200)
      end

      it 'should return 200 with day off from date and day off to date' do
        get :index, params: request_params
        expect(response.status).to eq(200)
      end

      it 'should return 200 with day off from date' do
        params = request_params.dup
        params.delete(:day_off_to_date)
        get :index, params: params
        expect(response.status).to eq(200)
      end

      it 'should return 200 with day off to date' do
        params = request_params.dup
        params.delete(:day_off_from_date)
        get :index, params: params
        expect(response.status).to eq(200)
      end

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
        get :index, params: { search: 'an'.upcase }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(2)
        expect(json_response['total_pages']).to eq(1)
        expect(json_response['total_count']).to eq(2)
      end

      it 'should pass with lower case' do
        get :index, params: { search: 'DU'.downcase }
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
        get :index, params: { search: '012345', per_page: 1, page: 1 }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(1)
        expect(json_response['total_pages']).to eq(5)
        expect(json_response['total_count']).to eq(5)
      end

      it 'should pass with token and params search and params pagination' do
        get :index, params: { per_page: 3, page: 2, search: '0123456789' }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(2)
        expect(json_response['page_size']).to eq(2)
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
        get :index, params: { per_page: 3, page: 2 }
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['pagination']
        expect(json_response['current_page']).to eq(2)
        expect(json_response['page_size']).to eq(2)
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
