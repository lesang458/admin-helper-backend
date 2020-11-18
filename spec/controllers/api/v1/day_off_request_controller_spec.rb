require 'rails_helper'

RSpec.describe Api::V1::DayOffRequestController, type: :controller do
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

  describe 'Destroy Day Off Request' do
    let!(:delete_params) { { id: DayOffRequest.first.id } }
    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      delete :destroy, params: delete_params
      expect(response.status).to eq(401)
    end

    it 'should return 403' do
      employee_token = JwtToken.encode({ user_id: @employee.id })
      headers = { authorization: "Bearer #{employee_token}" }
      request.headers.merge! headers
      delete :destroy, params: delete_params
      expect(response.status).to eq(403)
    end

    it 'should return 404' do
      delete :destroy, params: { id: 'not_found' }
      expect(response.status).to eq(404)
    end

    it 'should return 204' do
      delete :destroy, params: delete_params
      expect(response.status).to eq(204)
      expect(DayOffRequest.first.id).not_to eq delete_params[:id]
    end
  end

  describe 'GET# Day Off Request' do
    let!(:get_params) {
      {
        day_off_category_id: @day_off_category.id,
        from_date: '2020-07-14',
        to_date: '2020-07-20',
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

    it 'should return 200 with search by employee name' do
      get :index, params: { employee_name: 'dang' }
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)['meta']
      expect(json_response['current_page']).to eq(1)
      expect(json_response['page_size']).to eq(1)
      expect(json_response['total_pages']).to eq(1)
      expect(json_response['total_count']).to eq(1)
      expect(JSON.parse(response.body)['data'].first['user']['first_name']).to include('dang')
    end
  end

  describe 'PUT# Day Off Request' do
    let!(:put_params) {
      {
        id: DayOffRequest.first.id,
        day_off_category_id: @day_off_category.id,
        hours_per_day: 5,
        from_date: '2020-10-10',
        to_date: '2020-10-13',
        notes: 'Update success'
      }
    }
    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      put :update, params: put_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      employee_token = JwtToken.encode({ user_id: @employee.id })
      headers = { authorization: "Bearer #{employee_token}" }
      request.headers.merge! headers
      put :update, params: put_params
      expect(response.status).to eq(403)
    end

    it 'should return 200' do
      put :update, params: put_params
      day_off_request = DayOffRequest.first.reload
      expect(response.status).to eq(200)
      expect(day_off_request.hours_per_day).to eq(put_params[:hours_per_day])
      expect(day_off_request.from_date).to eq(put_params[:from_date])
      expect(day_off_request.to_date).to eq(put_params[:to_date])
      expect(day_off_request.notes).to eq(put_params[:notes])
      expect(day_off_request.day_off_info_id).to eq(@day_off_info.id)
    end

    it 'should return 422' do
      params = put_params.except(:day_off_category_id).merge({ day_off_category_id: @category_illness.id })
      put :update, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Invalid category or user'
    end

    it 'should return 422' do
      params = put_params.dup
      params[:from_date] = '2020-10-13'
      params[:to_date] = '2020-10-10'
      put :update, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include "From date can't be after To date"
    end

    it 'should return 404' do
      put :update, params: { id: 'not_found' }
      expect(response.status).to eq(404)
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
        day_off_category_id: @day_off_category.id
      }
    }

    it 'return status 401 status code with invalid token' do
      invalid_token = JwtToken.encode({ user_id: 'token false' })
      invalid_headers = { authorization: invalid_token }
      request.headers.merge! invalid_headers
      post :create, params: post_params
      expect(response.status).to eq(401)
    end

    it 'should return 201 with employee' do
      employee_token = JwtToken.encode({ user_id: @employee.id })
      headers = { authorization: "Bearer #{employee_token}" }
      request.headers.merge! headers
      post :create, params: post_params
      expect(response.status).to eq(201)
    end

    it 'should return 422 with unexist id' do
      params = post_params.dup
      params[:id] = unexist_id
      post :create, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Invalid category or user'
    end

    it 'should return 422 with status of day off cateogry inactived' do
      @day_off_category.inactive!
      post :create, params: post_params
      message = JSON.parse(response.body)['message']
      expect(response.status).to eq(422)
      expect(message).to include 'Day off category inactivated'
    end

    it 'should return 201' do
      post :create, params: post_params
      request = JSON.parse(response.body)['day_off_requests']
      expect(response.status).to eq(201)
      expect(request.count).to eq(1)
      expect(request.first['from_date'].to_date.to_s).to eq('2020-02-02')
      expect(request.first['to_date'].to_date.to_s).to eq('2020-07-07')
      expect(request.first['status'].to_s).to eq('pending')
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
      expect(requests.first['status'].to_s).to eq('pending')
      expect(requests.second['from_date'].to_date.to_s).to eq('2021-01-01')
      expect(requests.second['to_date'].to_date.to_s).to eq('2021-07-07')
      expect(requests.second['status'].to_s).to eq('pending')
    end

    it 'should return 422 with request in 3 years' do
      params = post_params.dup
      params[:to_date] = '2022-07-07'
      post :create, params: params
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['message']).to include 'Request is too long'
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
      expect(JSON.parse(response.body)['message']).to include "From date can't be blank, To date can't be blank"
    end

    it 'should return 422 with hours per day < 0' do
      params = post_params.dup
      params[:hours_per_day] = -1
      post :create, params: params
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['message']).to include 'Hours per day must be greater than 0'
    end

    it 'should return 422 without day_off_category_id' do
      post :create, params: post_params.except(:day_off_category_id)
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['message']).to include 'Invalid category or user'
    end

    it 'should return 422 with validate info' do
      params = post_params.dup
      params[:id] = @admin.id
      post :create, params: params
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['message']).to include 'Invalid category or user'
    end
  end

  describe 'PUT# Cancel Day Off Request' do
    let!(:put_params) {
      {
        id: DayOffRequest.first.id
      }
    }
    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      put :cancel, params: put_params
      expect(response.status).to eq(401)
    end

    it 'should return 200 with employee' do
      employee_token = JwtToken.encode({ user_id: @employee.id })
      headers = { authorization: "Bearer #{employee_token}" }
      request.headers.merge! headers
      put :cancel, params: put_params
      expect(response.status).to eq(200)
    end

    it 'should return 200' do
      put :cancel, params: put_params
      day_off_request = DayOffRequest.first.reload
      expect(response.status).to eq(200)
      expect(day_off_request.status).to eq('cancelled')
    end

    it 'should return 404' do
      put :cancel, params: { id: 'not_found' }
      expect(response.status).to eq(404)
    end

    it 'should return 400 with cancelled request' do
      DayOffRequest.first.cancelled!
      put :cancel, params: put_params
      expect(response.status).to eq(400)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Something went wrong when trying to cancel day_off_request'
    end

    it 'should return 400 with approved request' do
      DayOffRequest.first.approved!
      put :cancel, params: put_params
      expect(response.status).to eq(400)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Something went wrong when trying to cancel day_off_request'
    end

    it 'should return 400 with denied request' do
      DayOffRequest.first.denied!
      put :cancel, params: put_params
      expect(response.status).to eq(400)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Something went wrong when trying to cancel day_off_request'
    end
  end
end
