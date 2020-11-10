require 'rails_helper'

RSpec.describe Api::V1::Employees::DevicesController, type: :controller do
  before(:all) do
    DeviceHistory.delete_all
    User.delete_all
    Device.delete_all
    DeviceCategory.delete_all
    @admin = FactoryBot.create(:user, :admin, first_name: 'user', last_name: 'admin')
    @employee = FactoryBot.create(:user, :employee, first_name: 'user', last_name: 'employee')

    @category_phone = FactoryBot.create(:device_category, :phone)
    @iphone = FactoryBot.create(:device, user_id: @employee.id, name: 'Iphone 12 Pro Max', price: 39_990_000, device_category_id: @category_phone.id)

    @assigned = FactoryBot.create(:device_history, user_id: nil, device_id: @iphone.id, from_date: '2020-07-01', to_date: nil, status: 'IN_INVENTORY')
    @iphone_history = FactoryBot.create(:device_history, user_id: @admin.id, device_id: @iphone.id, from_date: '2020-07-30', to_date: nil, status: 'ASSIGNED')
    @assigned.update!(to_date: '2020-07-30')
    @iphone.update!(user_id: @admin.id)
  end

  let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
  let!(:valid_headers) { { authorization: "Bearer #{valid_token}" } }
  let!(:invalid_token) { SecureRandom.hex(64) }
  let!(:invalid_headers) { { authorization: "Bearer #{invalid_token}" } }
  let!(:invalid_price) { -999_999_999_999 }
  before(:each) { request.headers.merge! valid_headers }
  let!(:invalid_user_id) { 999_999_999_999 }

  describe 'GET#index device' do
    let!(:get_params) {
      {
        id: @admin.id
      }
    }

    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      get :index, params: get_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      valid_token = JwtToken.encode({ user_id: @employee.id })
      valid_headers = { authorization: "Bearer #{valid_token}" }
      request.headers.merge! valid_headers
      get :index, params: get_params
      expect(response.status).to eq(403)
    end

    it 'should return 404 with fake param id' do
      params = get_params.dup
      params[:id] = 'fake id'
      get :index, params: params
      expect(response.status).to eq(404)
      message = JSON.parse(response.body)['message']
      expect(message).to include "Couldn't find User with 'id'"
    end

    it 'should return 200' do
      get :index, params: get_params
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)['meta']
      expect(json_response['current_page']).to eq(1)
      expect(json_response['page_size']).to eq(1)
      expect(json_response['total_pages']).to eq(1)
      expect(json_response['total_count']).to eq(1)
    end
  end
end
