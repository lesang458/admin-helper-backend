require 'rails_helper'

RSpec.describe Api::V1::DevicesController, type: :controller do
  before(:all) do
    User.delete_all
    Device.delete_all
    DeviceCategory.delete_all
    DeviceHistory.delete_all

    @admin = FactoryBot.create(:user, :admin, first_name: 'user', last_name: 'admin')
    @employee = FactoryBot.create(:user, :employee, first_name: 'user', last_name: 'employee')

    @category_phone = FactoryBot.create(:device_category, :phone)
  end

  describe 'POST# device' do
    let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
    let!(:valid_headers) { { authorization: valid_token } }
    let!(:invalid_token) { SecureRandom.hex(64) }
    let!(:invalid_headers) { { authorization: invalid_token } }
    before(:each) { request.headers.merge! valid_headers }
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
        device_history: {
          user_id: '',
          from_date: '2020-10-10'
        }
      }
    }

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

    it 'should return 201 without phone_number' do
      params = post_params.dup
      params.delete(:user_id)
      post :create, params: params
      expect(response.status).to eq(201)
      response_body = JSON.parse(response.body)
      expect(response_body['device']['name']).to eq('iphone')
      expect(response_body['device']['price']).to eq(10_000_000)
      expect(response_body['device']['description']).to include 'Designed by Apple in California'
      expect(response_body['device']['device_category_name']).to eq('Iphone')
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
      params[:device_history][:from_date] = invalid_date
      post :create, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include "From date can't be blank"
    end
  end
end
