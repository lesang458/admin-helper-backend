require 'rails_helper'

RSpec.describe Api::V1::DayOffRequestController, type: :controller do
  before(:all) do
    DayOffRequest.delete_all
    DayOffInfo.delete_all
    DayOffCategory.delete_all
    @day_off_category = FactoryBot.create(:day_off_category, :vacation)
    @employee = FactoryBot.create(:user, :employee)
    @admin = FactoryBot.create(:user, :admin)
    @day_off_info = FactoryBot.create(:day_off_info, :vacation, user: @employee)
    FactoryBot.create_list(:day_off_request, 10, user: @employee, day_off_info: @day_off_info)
  end

  let!(:params) { { day_off_category_id: @day_off_category.id, from_date: '2020-07-14', to_date: '2020-07-20', id: @employee.id } }
  let!(:request_params) { { from_date: Time.now, to_date: Time.now, hours_per_day: 4, notes: 'ok', id: @admin.id, day_off_info_id: @day_off_info.id } }
  let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
  let!(:valid_headers) { { authorization: "Bearer #{valid_token}" } }
  let!(:invalid_token) { JwtToken.encode({ user_id: @employee.id }) }
  let!(:invalid_headers) { { authorization: "Bearer #{invalid_token}" } }
  before(:each) { request.headers.merge! valid_headers }

  describe 'Get Hisory' do
    it 'should return 403' do
      request.headers.merge! invalid_headers
      get :index, params: params
      expect(response.status).to eq(403)
    end

    it 'should return 200' do
      get :index, params: params
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)['pagination']
      expect(json_response['current_page']).to eq(1)
      expect(json_response['page_size']).to eq(10)
      expect(json_response['total_pages']).to eq(1)
      expect(json_response['total_count']).to eq(10)
    end
  end

  describe 'POST# Day Off Request' do
    let!(:unexist_id) { 999_999_999_999 }
    let!(:post_params) {
      {
        from_date: '2020-02-02',
        to_date: '2020-07-07',
        hours_per_day: 4,
        notes: 'ok',
        id: @employee,
        day_off_info_id: @day_off_info.id
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

    it 'should return 404 with unexist id' do
      params = post_params.dup
      params[:id] = unexist_id
      post :create, params: params
      expect(response.status).to eq(404)
      message = JSON.parse(response.body)['message']
      expect(message).to include "Couldn't find User with 'id'"
    end

    it 'should return 201' do
      post :create, params: post_params
      request = JSON.parse(response.body)['day_off_requests']
      expect(response.status).to eq(201)
      expect(request.count).to eq(1)
      expect(request.first['from_date'].to_date.to_s).to eq('2020-02-02')
      expect(request.first['to_date'].to_date.to_s).to eq('2020-07-07')
    end

    it 'should return 201 with request in 2 years' do
      params = post_params.dup
      params[:to_date] = '2021-07-07'
      post :create, params: params
      requests = JSON.parse(response.body)['day_off_requests']
      expect(response.status).to eq(201)
      expect(requests.count).to eq(2)
      expect(requests.first['from_date'].to_date.to_s).to eq('2020-02-02')
      expect(requests.first['to_date'].to_date.to_s).to eq('2020-12-31')
      expect(requests.second['from_date'].to_date.to_s).to eq('2021-01-01')
      expect(requests.second['to_date'].to_date.to_s).to eq('2021-07-07')
    end

    it 'should return 400 with request in 3 years' do
      params = post_params.dup
      params[:to_date] = '2022-07-07'
      post :create, params: params
      expect(JSON.parse(response.body)['message']).to include 'Request is too long'
      expect(response.status).to eq(400)
    end

    it 'should return 422 with from date after to date' do
      params = post_params.dup
      params[:from_date] = '2020-07-05'
      params[:to_date] = '2020-07-02'
      post :create, params: params
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['message']).to include "From date can't be after To date"
    end

    it 'should return 422 with from date or to date empty' do
      params = post_params.dup
      params[:from_date] = ''
      params[:to_date] = ''
      post :create, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 422 with hours per day < 0' do
      params = post_params.dup
      params[:hours_per_day] = -1
      post :create, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 422 without day_off_info_id' do
      params = post_params.dup
      params.delete(:day_off_info_id)
      post :create, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 422 with validate info' do
      params = post_params.dup
      params[:id] = @admin.id
      post :create, params: params
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['message']).to include 'Day off info user is not the same as requested user'
    end
  end
end
