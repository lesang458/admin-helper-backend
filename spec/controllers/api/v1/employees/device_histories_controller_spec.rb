require 'rails_helper'

RSpec.describe Api::V1::Employees::DeviceHistoriesController, type: :controller do
  before(:all) do
    DeviceHistory.delete_all
    Device.delete_all
    DeviceCategory.delete_all
    @phone = FactoryBot.create(:device_category, :phone)
    @iphone = FactoryBot.create(:device, :iphone, device_category: @phone)
    @admin = FactoryBot.create(:user, :admin)
    @employee = FactoryBot.create(:user, :employee)
    FactoryBot.create_list(:device_history, 10, from_date: '2020-07-15', to_date: '2020-07-31', status: 'IN_INVENTORY', device: @iphone)
    @device_history = FactoryBot.create(:device_history, from_date: '2020-07-31', to_date: '2020-08-15', status: 'ASSIGNED', device: @iphone, user: @employee)
  end
  let!(:request_params) { { id: @employee.id } }
  let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
  let!(:valid_headers) { { authorization: "Bearer #{valid_token}" } }
  let!(:invalid_token) { JwtToken.encode({ user_id: @employee.id }) }
  let!(:invalid_headers) { { authorization: "Bearer #{invalid_token}" } }
  before(:each) { request.headers.merge! valid_headers }

  describe 'Get Device Hisory' do
    it 'return status 401 status code with invalid token' do
      invalid_token = JwtToken.encode({ user_id: 'token false' })
      invalid_headers = { authorization: invalid_token }
      request.headers.merge! invalid_headers
      get :index, params: request_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      request.headers.merge! invalid_headers
      get :index, params: request_params
      expect(response.status).to eq(403)
    end

    it 'should return 404 with fake param id' do
      params = request_params.dup
      params[:id] = 'fake id'
      get :index, params: params
      expect(response.status).to eq(404)
      message = JSON.parse(response.body)['message']
      expect(message).to include "Couldn't find User with 'id'"
    end

    it 'should return 200' do
      get :index, params: request_params
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)['meta']
      expect(json_response['current_page']).to eq(1)
      expect(json_response['page_size']).to eq(1)
      expect(json_response['total_pages']).to eq(1)
      expect(json_response['total_count']).to eq(1)
    end
  end
end
