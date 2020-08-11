require 'rails_helper'

RSpec.describe Api::V1::DevicesController, type: :controller do
  before(:all) do
    DeviceHistory.delete_all
    User.delete_all
    Device.delete_all
    DeviceCategory.delete_all
    @admin = FactoryBot.create(:user, :admin, first_name: 'user', last_name: 'admin')
    @employee = FactoryBot.create(:user, :employee, first_name: 'user', last_name: 'employee')

    @category_phone = FactoryBot.create(:device_category, :phone)
    @iphone = FactoryBot.create(:device, user_id: @employee.id, name: 'Iphone 12 Pro Max', price: 39_990_000, device_category_id: @category_phone.id)
    @assigned = FactoryBot.create(:device_history, user_id: @employee.id, device_id: @iphone.id, status: 'ASSIGNED')
  end

  let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
  let!(:valid_headers) { { authorization: valid_token } }
  let!(:invalid_token) { SecureRandom.hex(64) }
  let!(:invalid_headers) { { authorization: invalid_token } }
  before(:each) { request.headers.merge! valid_headers }
  let!(:invalid_user_id) { 999_999_999_999 }

  describe 'DELETE# device' do
    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      delete :destroy, params: { id: @iphone.id }
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      valid_token = JwtToken.encode({ user_id: @employee.id })
      valid_headers = { authorization: valid_token }
      request.headers.merge! valid_headers
      delete :destroy, params: { id: @iphone.id }
      expect(response.status).to eq(403)
    end

    it 'should return 404 with invalid user_id' do
      delete :destroy, params: { id: invalid_user_id }
      expect(response.status).to eq(404)
      message = JSON.parse(response.body)['message']
      expect(message).to include "Couldn't find Device"
    end

    it 'should return 200' do
      delete :destroy, params: { id: @iphone.id }
      device = Device.find_by id: @iphone.id
      device_history = DeviceHistory.find_by device_id: @iphone.id
      expect(response.status).to eq(200)
      expect(device).to be_nil
      expect(device_history).to be_nil
    end
  end

  describe 'GET#index device' do
    let!(:get_params) {
      {
        status: 'ASSIGNED',
        user_id: @employee.id,
        device_category_id: @category_phone.id
      }
    }

    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      get :index, params: get_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      valid_token = JwtToken.encode({ user_id: @employee.id })
      valid_headers = { authorization: valid_token }
      request.headers.merge! valid_headers
      get :index, params: get_params
      expect(response.status).to eq(403)
    end

    it 'should return 200' do
      get :index, params: get_params
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)['pagination']
      expect(json_response['current_page']).to eq(1)
      expect(json_response['page_size']).to eq(1)
      expect(json_response['total_pages']).to eq(1)
      expect(json_response['total_count']).to eq(1)
    end

    it 'should return 200 with unexist status' do
      params = get_params.dup
      params[:status] = 'DISCARDED'
      get :index, params: params
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)['pagination']
      expect(json_response['current_page']).to eq(1)
      expect(json_response['page_size']).to eq(0)
      expect(json_response['total_pages']).to eq(0)
      expect(json_response['total_count']).to eq(0)
    end
  end

  describe 'GET#show device' do
    let!(:get_params) { { id: @iphone.id } }

    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      get :show, params: get_params
    end

    it 'should return 403 with employee' do
      valid_token = JwtToken.encode({ user_id: @employee.id })
      valid_headers = { authorization: valid_token }
      request.headers.merge! valid_headers
      get :show, params: get_params
      expect(response.status).to eq(403)
    end

    it 'should return 200' do
      get :show, params: get_params
      expect(response.status).to eq(200)
      response_body = JSON.parse(response.body)
      expect(response_body['device']['name']).to eq('Iphone 12 Pro Max')
      expect(response_body['device']['price']).to eq(39_990_000)
      expect(response_body['device']['device_category_id']).to eq(@category_phone.id)
      expect(response_body['device']['category_name']).to eq('Iphone')
    end
  end

  describe 'POST# device' do
    let!(:invalid_user_id) { 999_999_999_999 }
    let!(:invalid_name) { 'i' }
    let!(:invalid_price) { -999_999_999_999 }
    let!(:invalid_date) { '2020-50-40' }
    let!(:post_params) {
      {
        user_id: '',
        name: 'iphone',
        price: 10_000_000,
        description: 'Designed by Apple in California',
        device_category_id: @category_phone.id,
        from_date: '2020-10-10',
        status: 'ASSIGNED'
      }
    }

    let!(:without_history_params) {
      {
        user_id: '',
        name: 'iphone',
        price: 10_000_000,
        description: 'Designed by Apple in California',
        device_category_id: @category_phone.id
      }
    }

    describe 'params without history params' do
      it 'return status 401 status code with invalid token' do
        request.headers.merge! invalid_headers
        post :create, params: without_history_params
        expect(response.status).to eq(401)
      end

      it 'should return 403 with employee' do
        valid_token = JwtToken.encode({ user_id: @employee.id })
        valid_headers = { authorization: valid_token }
        request.headers.merge! valid_headers
        post :create, params: without_history_params
        expect(response.status).to eq(403)
      end

      it 'should return 201' do
        params = without_history_params.dup
        params.delete(:user_id)
        post :create, params: params
        expect(response.status).to eq(201)
        response_body = JSON.parse(response.body)
        expect(response_body['device']['name']).to eq('iphone')
        expect(response_body['device']['price']).to eq(10_000_000)
        expect(response_body['device']['description']).to include 'Designed by Apple in California'
        expect(response_body['device']['category_name']).to eq('Iphone')
      end

      it 'should return 404 with invalid user_id' do
        params = without_history_params.dup
        params[:user_id] = invalid_user_id
        post :create, params: params
        expect(response.status).to eq(404)
        message = JSON.parse(response.body)['message']
        expect(message).to include "Couldn't find User"
      end

      it 'should return 422 with invalid name' do
        params = without_history_params.dup
        params.delete(:user_id)
        params[:name] = invalid_name
        post :create, params: params
        expect(response.status).to eq(422)
        message = JSON.parse(response.body)['message']
        expect(message).to include 'Name is too short'
      end

      it 'should return 422 with invalid price' do
        params = without_history_params.dup
        params.delete(:user_id)
        params[:price] = invalid_price
        post :create, params: params
        expect(response.status).to eq(422)
        message = JSON.parse(response.body)['message']
        expect(message).to include 'Price must be greater than 0'
      end
    end

    describe 'params with history params' do
      it 'return status 401 status code with invalid token' do
        request.headers.merge! invalid_headers
        post :create, params: post_params
        expect(response.status).to eq(401)
      end

      it 'should return 403 with employee' do
        valid_token = JwtToken.encode({ user_id: @employee.id })
        valid_headers = { authorization: valid_token }
        request.headers.merge! valid_headers
        post :create, params: post_params
        expect(response.status).to eq(403)
      end

      it 'should return 201' do
        params = post_params.dup
        params.delete(:user_id)
        post :create, params: params
        expect(response.status).to eq(201)
        response_body = JSON.parse(response.body)
        expect(response_body['device']['name']).to eq('iphone')
        expect(response_body['device']['price']).to eq(10_000_000)
        expect(response_body['device']['description']).to include 'Designed by Apple in California'
        expect(response_body['device']['category_name']).to eq('Iphone')
      end

      it 'should return 404 with invalid user_id' do
        params = post_params.dup
        params[:user_id] = invalid_user_id
        post :create, params: params
        expect(response.status).to eq(404)
        message = JSON.parse(response.body)['message']
        expect(message).to include "Couldn't find User"
      end

      it 'should return 422 with invalid name' do
        params = post_params.dup
        params.delete(:user_id)
        params[:name] = invalid_name
        post :create, params: params
        expect(response.status).to eq(422)
        message = JSON.parse(response.body)['message']
        expect(message).to include 'Name is too short'
      end

      it 'should return 422 with invalid price' do
        params = post_params.dup
        params.delete(:user_id)
        params[:price] = invalid_price
        post :create, params: params
        expect(response.status).to eq(422)
        message = JSON.parse(response.body)['message']
        expect(message).to include 'Price must be greater than 0'
      end

      it 'should return 422 with invalid from_date' do
        params = post_params.dup
        params.delete(:user_id)
        params[:from_date] = invalid_date
        post :create, params: params
        expect(response.status).to eq(422)
        message = JSON.parse(response.body)['message']
        expect(message).to include "From date can't be blank"
      end

      it 'should return 422 with invalid status' do
        params = post_params.dup
        params.delete(:user_id)
        params[:status] = 'invalid status'
        post :create, params: params
        expect(response.status).to eq(422)
        message = JSON.parse(response.body)['message']
        expect(message).to include 'is not a valid status'
      end
    end
  end
end
