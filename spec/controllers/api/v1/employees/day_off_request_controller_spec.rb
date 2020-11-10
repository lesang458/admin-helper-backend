require 'rails_helper'

RSpec.describe Api::V1::Employees::DayOffRequestController, type: :controller do
  before(:all) do
    DayOffRequest.delete_all
    DayOffInfo.delete_all
    DayOffCategory.delete_all
    @day_off_category = FactoryBot.create(:day_off_category, :vacation)
    @category_illness = FactoryBot.create(:day_off_category, :illness)
    @employee = FactoryBot.create(:user, :employee)
    @admin = FactoryBot.create(:user, :admin, first_name: 'danghanh')
    @day_off_info = FactoryBot.create(:day_off_info, :vacation, user: @employee)
    @illness_info = FactoryBot.create(:day_off_info, :illness, user: @admin)
    FactoryBot.create_list(:day_off_request, 10, user: @employee, day_off_info: @day_off_info)
    @admin_request = FactoryBot.create(:day_off_request, user: @admin, day_off_info: @illness_info)
  end

  let!(:params) { { day_off_category_id: @day_off_category.id, from_date: '2020-07-14', to_date: '2020-07-20', id: @employee.id } }
  let!(:request_params) { { from_date: Time.now, to_date: Time.now, hours_per_day: 4, notes: 'ok', id: @admin.id, day_off_info_id: @day_off_info.id } }
  let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
  let!(:valid_headers) { { authorization: "Bearer #{valid_token}" } }
  let!(:invalid_token) { SecureRandom.hex(64) }
  let!(:invalid_headers) { { authorization: "Bearer #{invalid_token}" } }
  before(:each) { request.headers.merge! valid_headers }

  describe 'GET# Day Off Request' do
    let!(:get_params) {
      {
        id: @employee.id
      }
    }
    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      get :index, params: get_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 status code' do
      employee_token = JwtToken.encode({ user_id: @employee.id })
      headers = { authorization: "Bearer #{employee_token}" }
      request.headers.merge! headers
      get :index, params: get_params
      expect(response.status).to eq(403)
    end

    it 'should return 200' do
      get :index, params: get_params
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)['meta']
      expect(json_response['current_page']).to eq(1)
      expect(json_response['page_size']).to eq(10)
      expect(json_response['total_pages']).to eq(1)
      expect(json_response['total_count']).to eq(10)
    end
  end
end
