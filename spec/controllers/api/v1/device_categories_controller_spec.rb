require 'rails_helper'

RSpec.describe Api::V1::DeviceCategoriesController, type: :controller do
  before(:all) do
    DeviceCategory.delete_all
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
      json_response = JSON.parse(response.body)
      expect(json_response['pagination']['current_page']).to eq(1)
      expect(json_response['pagination']['page_size']).to eq(4)
      expect(json_response['pagination']['total_pages']).to eq(1)
      expect(json_response['pagination']['total_count']).to eq(4)
    end

    it 'should return 200' do
      get :index, params: { page: 1, per_page: 3 }
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response['pagination']['current_page']).to eq(1)
      expect(json_response['pagination']['page_size']).to eq(3)
      expect(json_response['pagination']['total_pages']).to eq(2)
      expect(json_response['pagination']['total_count']).to eq(4)
    end
  end

  describe 'Get detail Device Category' do
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

  describe 'POST# device category' do
    let!(:invalid_name) { '' }
    let!(:post_params) {
      {
        name: 'iphone',
        description: 'Designed by Apple in California'
      }
    }
    it 'return status 401 status code with invalid token' do
      invalid_token = JwtToken.encode({ user_id: 'token false' })
      invalid_headers = { authorization: invalid_token }
      request.headers.merge! invalid_headers
      post :create, params: post_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      request.headers.merge! invalid_headers
      post :create, params: post_params
      expect(response.status).to eq(403)
    end

    it 'should return 201' do
      post :create, params: post_params
      expect(response.status).to eq(201)
      response_body = JSON.parse(response.body)
      expect(response_body['device_category']['name']).to eq('iphone')
      expect(response_body['device_category']['description']).to include 'Designed by Apple in California'
    end

    it 'should return 422 with invalid name' do
      params = post_params.dup
      params[:name] = invalid_name
      post :create, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Name can'
    end
  end

  describe 'Destroy device category' do
    let!(:params) { { id: @laptop.id } }
    it 'return status 401 status code with invalid token' do
      invalid_token = JwtToken.encode({ user_id: 'token false' })
      invalid_headers = { authorization: invalid_token }
      request.headers.merge! invalid_headers
      delete :destroy, params: params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      request.headers.merge! invalid_headers
      delete :destroy, params: params
      expect(response.status).to eq(403)
    end

    it 'should return 404' do
      delete :destroy, params: { id: 'IDnotfound' }
      expect(response.status).to eq(404)
    end

    it 'should return 200' do
      list_categories = []
      delete :destroy, params: params
      expect(response.status).to eq(200)
      response_body = JSON.parse(response.body)
      response_body.each do |response|
        list_categories.push(response['id'.to_i])
      end
      expect(list_categories).not_to include @laptop.id
    end
  end
end
