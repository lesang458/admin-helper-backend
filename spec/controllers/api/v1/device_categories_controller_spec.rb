require 'rails_helper'

RSpec.describe Api::V1::DeviceCategoriesController, type: :controller do
  before(:all) do
    @admin = FactoryBot.create :user, :admin
    @employee = FactoryBot.create :user, :employee
    @laptop = FactoryBot.create :device_category, :laptop
    @phone = FactoryBot.create :device_category, :phone
    @tablet = FactoryBot.create :device_category, :tablet
    @monitor = FactoryBot.create :device_category, :monitor
  end

  let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
  let!(:valid_headers) { { authorization: valid_token } }
  let!(:invalid_token) { JwtToken.encode({ user_id: @employee.id }) }
  let!(:invalid_headers) { { authorization: invalid_token } }
  before(:each) { request.headers.merge! valid_headers }

  describe 'PUT# device category' do
    let!(:unexist_id) { 999_999_999_999 }
    let!(:put_params) {
      {
        id: @phone.id,
        name: 'update name',
        description: 'update description'
      }
    }

    it 'return status 401 status code with invalid token' do
      invalid_token = JwtToken.encode({ user_id: 'token false' })
      invalid_headers = { authorization: invalid_token }
      request.headers.merge! invalid_headers
      put :update, params: put_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      request.headers.merge! invalid_headers
      put :update, params: put_params
      expect(response.status).to eq(403)
    end

    it 'should return 404 with unexist device_id' do
      params = put_params.dup
      params[:id] = unexist_id
      put :update, params: params
      expect(response.status).to eq(404)
      message = JSON.parse(response.body)['message']
      expect(message).to include "Couldn't find DeviceCategory with 'id'"
    end

    it 'should return 422 with empty name' do
      params = put_params.dup
      params[:name] = ''
      put :update, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include "Name can't be blank"
    end

    it 'should return 200' do
      put :update, params: put_params
      @phone.reload
      expect(response.status).to eq(200)
      expect(@phone.name).to eq('update name')
      expect(@phone.description).to eq('update description')
      # Check Cache
      updated_phone = DeviceCategory.all_categories.find @phone.id
      expect(updated_phone.name).to eq('update name')
      expect(updated_phone.description).to eq('update description')
    end
  end

  describe 'Get list device category' do
    it 'return status 401 status code with invalid token' do
      invalid_token = JwtToken.encode({ user_id: 'token false' })
      invalid_headers = { authorization: invalid_token }
      request.headers.merge! invalid_headers
      get :index
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      request.headers.merge! invalid_headers
      get :index
      expect(response.status).to eq(403)
    end

    it 'should return 200' do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET# detail Device Category' do
    it 'return status 401 status code with invalid token' do
      invalid_token = JwtToken.encode({ user_id: 'token false' })
      invalid_headers = { authorization: invalid_token }
      request.headers.merge! invalid_headers
      get :show, params: { id: @laptop.id }
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      request.headers.merge! invalid_headers
      get :show, params: { id: @laptop.id }
      expect(response.status).to eq(403)
    end

    it 'should return 404 with ID does not exist' do
      request.headers.merge! valid_headers
      get :show, params: { id: '404notfound' }
      expect(response.status).to eq(404)
    end

    it 'should return 200 with ID already exists' do
      request.headers.merge! valid_headers
      get :show, params: { id: @laptop.id }
      json_response = JSON.parse(response.body)
      expect(json_response['device_category']['name']).to eq(@laptop.name)
      expect(response.status).to eq(200)
    end
  end
end
